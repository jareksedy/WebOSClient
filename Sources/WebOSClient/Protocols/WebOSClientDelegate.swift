//
//  WebOSClientDelegate.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

public typealias WebOSResponseResult = Result<WebOSResponse, Error>

public protocol WebOSClientDelegate: AnyObject {
    func didConnect()
    func didPrompt()
    func didRegister(with clientKey: String)
    func didReceive(_ result: WebOSResponseResult)
    func didReceive(jsonResponse: String)
    func didReceiveNetworkError(_ error: Error?)
    func didDisconnect()
}

public extension WebOSClientDelegate {
    func didConnect() {}
    func didPrompt() {}
    func didReceive(jsonResponse: String) {}
    func didDisconnect() {}
}
