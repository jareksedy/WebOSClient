//
//  ViewModel.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 12.01.2024.
//

import SwiftUI
import WebOSClient

class ViewModel: ObservableObject {
    enum Constants {
        static let tvIPKey = "tvIPKey"
        static let registrationTokenKey = "clientKey"
        static let volumeSubscriptionRequestId = "volumeSubscription"
        static let foregroundAppRequestId = "foregroundAppSubscription"
        static let soundOutputRequestId = "soundOutputSubscription"
        static let appsRequestId = "listAppsRequest"
        static let keyboardRequestId = "keyboardRequest"
        static let logSuffix = "\n"
    }
    
    @Published var isConnected: Bool = false
    @Published var showPromptAlert: Bool = false
    @Published var log: String = ""
    @Published var apps: [WebOSResponseApplication] = []
    
    // Subscriptions
    @Published var volumeLevel: Double = 0
    @Published var foregroundApp: String = "N/A"
    @Published var soundOutput: WebOSSoundOutputType? = nil
    @Published var currentTextField: WebOSResponseCurrentWidget? = nil
    
    private var installedApps: [WebOSResponseApplication] = []
    
    var tv: WebOSClientProtocol?
    
    init() {
        let ip = UserDefaults.standard.value(forKey: Constants.tvIPKey) as? String
        connectAndRegister(with: ip)
    }
    
    func connectAndRegister(with ip: String?) {
        guard !isConnected else { return }
        if let ip {
            let urlString = "wss://\(ip):3001"
            let url = URL(string: urlString)
            self.tv = WebOSClient(url: url, delegate: self)
            tv?.connect()
            let registrationToken = UserDefaults.standard.value(forKey: Constants.registrationTokenKey) as? String
            tv?.send(.register(clientKey: registrationToken))
        }
    }
    
    func subscribeAll() {
        tv?.send(.getVolume(subscribe: true), id: Constants.volumeSubscriptionRequestId)
        tv?.send(.getForegroundApp(subscribe: true), id: Constants.foregroundAppRequestId)
        tv?.send(.getSoundOutput(subscribe: true), id: Constants.soundOutputRequestId)
        tv?.send(.registerRemoteKeyboard, id: Constants.keyboardRequestId)
    }
    
    func showAllApps() {
        guard isConnected else { return }
        apps = installedApps
    }
    
    func showNonSystemApps() {
        guard isConnected else { return }
        apps = installedApps.filter { $0.systemApp == false }
    }
    
    func showSystemApps() {
        guard isConnected else { return }
        apps = installedApps.filter { $0.systemApp == true }
    }
}

extension ViewModel: WebOSClientDelegate {
    func didConnect() {
        Task { @MainActor in
            log += "[CONNECTED]" + Constants.logSuffix
        }
    }
    
    func didPrompt() {
        Task { @MainActor in
            showPromptAlert = true
        }
    }
    
    func didRegister(with clientKey: String) {
        UserDefaults.standard.setValue(clientKey, forKey: Constants.registrationTokenKey)
        subscribeAll()
        tv?.send(.listApps, id: Constants.appsRequestId)
        Task { @MainActor in
            isConnected = true
        }
    }
    
    func didReceive(_ result: Result<WebOSResponse, Error>) {
        if case .success(let response) = result, response.id == Constants.volumeSubscriptionRequestId {
            Task { @MainActor in
                self.volumeLevel = Double(response.payload?.volumeStatus?.volume ?? 0)
            }
        }
        if case .success(let response) = result, response.id == Constants.foregroundAppRequestId {
            Task { @MainActor in
                self.foregroundApp = response.payload?.appId ?? ""
            }
        }
        if case .success(let response) = result, response.id == Constants.soundOutputRequestId {
            Task { @MainActor in
                self.soundOutput = WebOSSoundOutputType(rawValue: response.payload?.soundOutput ?? "tv_speaker") ?? .tv_speaker
            }
        }
        if case .success(let response) = result, response.id == Constants.appsRequestId {
            Task { @MainActor in
                self.installedApps = response.payload?.applications ?? []
                self.showNonSystemApps()
            }
        }
        if case .success(let response) = result, response.id == Constants.keyboardRequestId {
            Task { @MainActor in
                self.currentTextField = response.payload?.currentWidget
            }
        }
    }
    
    func didReceive(jsonResponse: String) {
        Task { @MainActor in
            log += jsonResponse.prettyPrintedJSONString!.debugDescription + Constants.logSuffix
        }
    }
    
    func didReceiveNetworkError(_ error: Error?) {
        Task { @MainActor in
            log += "[ERROR: \(error?.localizedDescription ?? "unknown")]" + Constants.logSuffix
            isConnected = false
            tv?.disconnect()
        }
    }
    
    func didDisconnect() {
        Task { @MainActor in
            isConnected = false
            log += "[DISCONNECTED]" + Constants.logSuffix
        }
    }
}
