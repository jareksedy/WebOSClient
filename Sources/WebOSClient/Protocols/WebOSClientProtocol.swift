//
//  WebOSClientProtocol.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

public protocol WebOSClientProtocol {
    var delegate: WebOSClientDelegate? { get set }
    func connect()
    @discardableResult func send(_ target: WebOSTarget, id: String) -> String?
    func send(_ jsonRequest: String)
    func sendKey(_ key: WebOSKeyTarget)
    func sendKey(_ data: Data)
    func sendPing()
    func disconnect()
}

extension WebOSClientProtocol {
    @discardableResult func send(_ target: WebOSTarget, id: String = UUID().uuidString.lowercased()) -> String? {
        send(target, id: id)
    }
}
