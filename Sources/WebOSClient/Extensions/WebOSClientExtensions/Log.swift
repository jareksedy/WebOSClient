//
//  Log.swift
//  Created by Yaroslav Sedyshev on 27.07.2024.
//

import Foundation

fileprivate let logPrefixSent = "[WEBOSCLIENT][SENT]:"
fileprivate let logPrefixReceivedSuccess = "[WEBOSCLIENT][RECEIVED]:"
fileprivate let logPrefixReceivedError = "[WEBOSCLIENT][RECEIVED ERROR]:"

extension WebOSClient {
    func log(_ message: URLSessionWebSocketTask.Message) {
        guard shouldLogActivity else {
            return
        }
        switch message {
        case .string(let stringMessage):
            NSLog("\(logPrefixSent) %@", stringMessage.prettyPrintedOrPlain)
        case .data(let dataMessage):
            if let messageString = String(data: dataMessage, encoding: .utf8) {
                NSLog("\(logPrefixSent) %@", messageString)
            } else {
                NSLog("\(logPrefixSent) Unable to parse data to string.")
            }
        @unknown default:
            NSLog("\(logPrefixSent) Unknown message type.")
        }
    }
    
    func log(_ response: Result<URLSessionWebSocketTask.Message, any Error>) {
        guard shouldLogActivity else {
            return
        }
        switch response {
        case .success(let message):
            if case .string(let stringMessage) = message {
                NSLog("\(logPrefixReceivedSuccess) %@", stringMessage.prettyPrintedOrPlain)
            }
        case .failure(let error):
            NSLog("\(logPrefixReceivedError) %@", error.localizedDescription)
        }
    }
    
    func log(_ message: String) {
        guard shouldLogActivity else {
            return
        }
        NSLog("\(logPrefixSent) %@", message.prettyPrintedOrPlain)
    }
}
