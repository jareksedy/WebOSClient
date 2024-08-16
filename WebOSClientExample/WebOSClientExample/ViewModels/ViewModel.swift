//
//  ViewModel.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 12.01.2024.
//

import SwiftUI
import Combine
import WebOSClient

class ViewModel: ObservableObject {
    enum Constants {
        static let tvIPKey = "tvIPKey"
        static let registrationTokenKey = "clientKey"
        static let volumeSubscriptionRequestId = "volumeSubscription"
        static let foregroundAppRequestId = "foregroundAppSubscription"
        static let foregroundAppMediaInfoRequestId = "foregroundAppMediaInfoSubscription"
        static let soundOutputRequestId = "soundOutputSubscription"
        static let appsRequestId = "listAppsRequest"
        static let keyboardRequestId = "keyboardRequest"
        static let powerStateRequestId = "powerStateSubscription"
        static let mediaPlaybackInfoRequestId = "mediaPlaybackInfoSubscription"
        static let logSuffix = "\n"
    }
    
    @Published var pinPairing: Bool = false
    @Published var isConnected: Bool = false
    @Published var showPromptAlert: Bool = false
    @Published var showPinAlert: Bool = false
    @Published var logOutput = ""
    @Published var apps: [WebOSResponseApplication] = []
    
    // Subscriptions
    @Published var volumeLevel: Double = 0
    @Published var foregroundApp: String = "N/A"
    @Published var soundOutput: WebOSSoundOutputType? = nil
    @Published var currentTextField: WebOSResponseCurrentWidget? = nil
    @Published var currentPlayState: String = "N/A"
    @Published var currentPowerState: String = "N/A"
    
    private var installedApps: [WebOSResponseApplication] = []
    
    private let pipe = Pipe()
    private let logQueue = DispatchQueue(label: "LogCaptureQueue")
    
    var tv: WebOSClientProtocol?
    
    init() {
        let ip = UserDefaults.standard.value(forKey: Constants.tvIPKey) as? String
        connectAndRegister(with: ip)
        setupLogCapture()
    }
    
    func connectAndRegister(with ip: String?) {
        guard !isConnected, let ip else { return }
        let urlString = "wss://\(ip):3001"
        guard let url = URL(string: urlString) else { return }
        self.tv = WebOSClient(url: url, delegate: self, shouldLogActivity: true)
        tv?.connect()
        let registrationToken = UserDefaults.standard.value(forKey: Constants.registrationTokenKey) as? String
        if pinPairing {
            tv?.send(.register(pairingType: .pin))
        } else {
            tv?.send(.register(clientKey: registrationToken))
        }
    }
    
    func subscribeAll() {
        tv?.send(.getVolume(subscribe: true), id: Constants.volumeSubscriptionRequestId)
        tv?.send(.getForegroundApp(subscribe: true), id: Constants.foregroundAppRequestId)
        tv?.send(.getForegroundAppMediaStatus(subscribe: true), id: Constants.foregroundAppMediaInfoRequestId)
        tv?.send(.getSoundOutput(subscribe: true), id: Constants.soundOutputRequestId)
        tv?.send(.registerRemoteKeyboard, id: Constants.keyboardRequestId)
        tv?.send(.getPowerState(subscribe: true), id: Constants.powerStateRequestId)
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
    
    func clearLogs() {
        Task { @MainActor in
            logOutput = ""
        }
    }
    
    func setupLogCapture() {
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let self = self else { return }
            let data = handle.availableData
            if let str = String(data: data, encoding: .utf8) {
                let filteredStr = self.filterMetadata(from: str)
                self.logQueue.async {
                    Task { @MainActor in
                        self.logOutput.append(contentsOf: filteredStr)
                    }
                }
            }
        }
    }
    
    private func filterMetadata(from log: String) -> String {
        let pattern = #"OSLOG-[A-F0-9-]+ \d+ \d+ [A-Z] \w+ \{[^}]+\}\t"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) {
            let range = NSRange(location: 0, length: log.utf16.count)
            return regex.stringByReplacingMatches(in: log, options: [], range: range, withTemplate: "")
        } else {
            return log
        }
    }
}

extension ViewModel: WebOSClientDelegate {
    func didPrompt() {
        Task { @MainActor in
            showPromptAlert = true
        }
    }
    
    func didDisplayPin() {
        Task { @MainActor in
            showPinAlert = true
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
        if case .success(let response) = result, response.id == Constants.foregroundAppMediaInfoRequestId {
            Task { @MainActor in
                self.currentPlayState = response.payload?.foregroundAppInfo?.first?.playState ?? ""
            }
        }
        if case .success(let response) = result, response.id == Constants.soundOutputRequestId {
            Task { @MainActor in
                self.soundOutput = WebOSSoundOutputType(rawValue: response.payload?.soundOutput ?? "tv_speaker") ?? .tvSpeaker
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
        if case .success(let response) = result, response.id == Constants.mediaPlaybackInfoRequestId {
            Task { @MainActor in
                self.currentPlayState = ""
            }
        }
        if case .success(let response) = result, response.id == Constants.powerStateRequestId {
            Task { @MainActor in
                self.currentPowerState = "\(response.payload?.state ?? "—"); \(response.payload?.onOff ?? "—"); \(response.payload?.processing ?? "—"); \(response.payload?.reason ?? "—")"
            }
        }
        if case .failure(let error) = result {
            let errorMessage = error.localizedDescription
            // Pairing rejected by the user or invalid pin.
            if errorMessage.contains("rejected pairing") {
                Task { @MainActor in
                    showPromptAlert = false
                    showPinAlert = false
                }
            }
            // Pairing cancelled due to a timeout.
            if errorMessage.contains("cancelled") {
                Task { @MainActor in
                    showPromptAlert = false
                    showPinAlert = false
                }
            }
        }
    }
    
    func didReceiveNetworkError(_ error: Error?) {
        Task { @MainActor in
            isConnected = false
            tv?.disconnect()
        }
    }
    
    func didDisconnect() {
        Task { @MainActor in
            isConnected = false
        }
    }
}
