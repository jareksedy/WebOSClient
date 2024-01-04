//
//  WebOSClientDelegate.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

/// Methods for handling various events in the WebOSClient.
public protocol WebOSClientDelegate: AnyObject {
    
    /// Invoked when the client successfully establishes a connection.
    func didConnect()
    
    /// Invoked when the TV prompts for registration.
    func didPrompt()
    
    /// Invoked when the client successfully registers with a client key.
    /// - Parameter clientKey: The client key for registration.
    func didRegister(with clientKey: String)
    
    /// Invoked when the client receives a response from the WebOS service.
    /// - Parameter result: The result containing either a WebOSResponse or an error.
    func didReceive(_ result: Result<WebOSResponse, Error>)
    
    /// Invoked when the client receives a response from the WebOS service.
    /// - Parameter jsonResponse: Raw JSON response received from the WebOS service.
    func didReceive(jsonResponse: String)
    
    /// Invoked when the client encounters a network-related error, like abnormal disconnect.
    /// - Parameter error: The error object representing the network error, if any.
    func didReceiveNetworkError(_ error: Error?)
    
    /// Invoked when the client disconnects from the WebOS websocket service.
    func didDisconnect()
}

public extension WebOSClientDelegate {
    func didConnect() {}
    func didPrompt() {}
    func didReceive(_ result: Result<WebOSResponse, Error>) {}
    func didReceive(jsonResponse: String) {}
    func didDisconnect() {}
}
