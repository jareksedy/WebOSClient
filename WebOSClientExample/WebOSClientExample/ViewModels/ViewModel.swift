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
}

class ViewModel: ObservableObject {
    @Published var volumeLevel: Double
    @Published var showPromptAlert: Bool = false
    
    var tv: WebOSClientProtocol?
    
    // Specify your TV URL here
    private let urlString = "wss://192.168.8.10:3001"
    
    init() {
        volumeLevel = 0
        let url = URL(string: urlString)
        self.tv = WebOSClient(url: url, delegate: self)
        tv?.connect()
        let registrationToken = UserDefaults.standard.value(forKey: Constants.registrationTokenKey) as? String
        tv?.send(.register(clientKey: registrationToken))
    }
}

extension ViewModel: WebOSClientDelegate {
    func didPrompt() {
        showPromptAlert = true
    }
    
    func didRegister(with clientKey: String) {
        UserDefaults.standard.setValue(clientKey, forKey: Constants.registrationTokenKey)
        tv?.send(.getVolume(subscribe: true), id: Constants.volumeSubscriptionRequestId)
    }
    
    func didReceive(_ result: Result<WebOSResponse, Error>) {
        if case .success(let response) = result, response.id == Constants.volumeSubscriptionRequestId {
            Task { @MainActor in
                self.volumeLevel = Double(response.payload?.volumeStatus?.volume ?? 0)
            }
        }
    }
    
    func didReceiveNetworkError(_ error: Error?) {
    }
}
