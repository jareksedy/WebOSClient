//
//  SendPing.swift
//  Created by Yaroslav Sedyshev on 27.07.2024.
//

import Foundation

extension WebOSClient {
    func sendPing(task: URLSessionWebSocketTask?) {
        task?.sendPing { [weak self] error in
            guard let self else {
                return
            }
            if let error {
                delegate?.didReceiveNetworkError(error)
                log("Failed to send ping with error: \(error)")
            } else {
                log("Ping. Task: \(String(describing: task)).")
            }
        }
    }
}
