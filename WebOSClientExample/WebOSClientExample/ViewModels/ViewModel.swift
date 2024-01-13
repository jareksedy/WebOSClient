//
//  ViewModel.swift
//  WebOSClientExample
//
//  Created by Ярослав on 12.01.2024.
//

import SwiftUI
import WebOSClient

fileprivate enum Constants {
    static let registrationTokenKey = "clientKey"
    static let volumeSubscriptionRequestId = "volumeSubscription"
    static let foregroundAppRequestId = "foregroundAppSubscription"
    static let soundOutputRequestId = "soundOutputSubscription"
}

class ViewModel: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var showPromptAlert: Bool = false
    
    // Subscriptions
    @Published var volumeLevel: Double = 0
    @Published var foregroundApp: String = "N/A"
    @Published var soundOutput: WebOSSoundOutputType? = nil
    
    var tv: WebOSClientProtocol?
    
    // Specify your TV URL here
    private let urlString = "wss://192.168.8.10:3001"
    
    init() {
        let url = URL(string: urlString)
        self.tv = WebOSClient(url: url, delegate: self)
        connectAndRegister()
    }
    
    func connectAndRegister() {
        tv?.connect()
        let registrationToken = UserDefaults.standard.value(forKey: Constants.registrationTokenKey) as? String
        tv?.send(.register(clientKey: registrationToken))
    }
    
    func subscribeAll() {
        tv?.send(.getVolume(subscribe: true), id: Constants.volumeSubscriptionRequestId)
        tv?.send(.getForegroundApp(subscribe: true), id: Constants.foregroundAppRequestId)
        tv?.send(.getSoundOutput(subscribe: true), id: Constants.soundOutputRequestId)
    }
}

extension ViewModel: WebOSClientDelegate {
    func didPrompt() {
        Task { @MainActor in
            showPromptAlert = true
        }
    }
    
    func didRegister(with clientKey: String) {
        UserDefaults.standard.setValue(clientKey, forKey: Constants.registrationTokenKey)
        subscribeAll()
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
    }
    
    func didReceiveNetworkError(_ error: Error?) {
        Task { @MainActor in
            isConnected = false
        }
    }
}
