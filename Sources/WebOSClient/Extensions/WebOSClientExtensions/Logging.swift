//
//  Logging.swift
//  Created by Yaroslav Sedyshev on 27.07.2024.
//

import Foundation

fileprivate enum Constants {
    static let logPrefix = "[ WebOSClient ]:"
    static let logPrefixConnected = "[ WebOSClient ][ CONNECTED ]"
    static let logPrefixDisconnected = "[ WebOSClient ][ DISCONNECTED ]"
    static let logErrorPrefix = "[ WebOSClient ][ ERROR ]:"
    static let logPrefixSent = "[ WebOSClient ][ ↑ ]:"
    static let logPrefixReceivedSuccess = "[ WebOSClient ][ ↓ ]:"
    static let logPrefixReceivedError = "[ WebOSClient ][ ERROR ][ ↓ ]:"
    static let logPingSent = "[ WebOSClient ][ PING ][ ↑ ]:"
    static let logPongReceived = "[ WebOSClient ][ PONG ][ ↓ ]:"
}

extension WebOSClient {
    func logSentMessage(_ message: URLSessionWebSocketTask.Message) {
        guard shouldLogActivity else {
            return
        }
        if case .string(let stringMessage) = message {
            NSLog("\(Constants.logPrefixSent)\n%@", stringMessage.prettyPrinted)
        }
        if case .data(let dataMessage) = message {
            let messageString = String(data: dataMessage, encoding: .utf8) ?? "Unable to parse data message."
            NSLog("\(Constants.logPrefixSent) %@", messageString.replacingOccurrences(of: "\n", with: " "))
        }
    }
    
    func logReceivedResponse(_ response: Result<URLSessionWebSocketTask.Message, any Error>) {
        guard shouldLogActivity else {
            return
        }
        if case .success(let message) = response, case .string(let stringMessage) = message {
            NSLog("\(Constants.logPrefixReceivedSuccess)\n%@", stringMessage.prettyPrinted)
        } else if case .failure(let error) = response {
            NSLog("\(Constants.logPrefixReceivedError) %@.", error.localizedDescription)
        }
    }
    
    func logPing(_ message: String) {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPingSent) %@", message)
    }
    
    func logPong(_ message: String) {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPongReceived) %@", message)
    }
    
    func logPongError(_ errorMessage: String) {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPrefixReceivedError) %@.", errorMessage)
    }
    
    func logMessage(_ message: String) {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPrefix) %@", message)
    }
    
    func logConnected() {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPrefixConnected)")
    }
    
    func logDisconnected() {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(Constants.logPrefixDisconnected)")
    }
    
    func logError(_ errorMessage: String?) {
        guard shouldLogActivity, let errorMessage else {
            return
        }
        NSLog("\(Constants.logErrorPrefix) %@.", errorMessage)
    }
}
