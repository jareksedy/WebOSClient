//
//  WebOSClientProtocol.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

/// A protocol defining methods for interacting with TV.
public protocol WebOSClientProtocol {
    /// Determines if the client should log all activity. Can be set at any time.
    var shouldLogActivity: Bool { get set }

    /// The delegate responsible for handling various events.
    var delegate: WebOSClientDelegate? { get set }

    /// Initializes a new instance of the WebOS client.
    /// - Parameters:
    ///   - url: The URL of the WebOS server.
    ///   - delegate: An optional delegate conforming to the WebOSClientDelegate protocol. It will receive notifications about the client's events.
    ///   - shouldPerformHeartbeat: Boolean indicating whether the client should perform heartbeat requests to the server. Default is true.
    ///   - heartBeatTimeInterval: The time interval (in seconds) between heartbeat requests. Default is 10 seconds.
    ///   - shouldLogActivity: Determines whether the client should log all activity. Default is false.
    /// - Returns: A new instance of WebOSClient.
    /// - Note: The url parameter must be provided for the client to establish a connection with the WebOS server.
    init(
        url: URL,
        delegate: WebOSClientDelegate?,
        shouldPerformHeartbeat: Bool,
        heartbeatTimeInterval: TimeInterval,
        shouldLogActivity: Bool
    )

    /// Establishes a connection to the TV.
    func connect()

    /// Sends a request to the specified WebOSTarget and returns the unique identifier of the request.
    /// - Parameters:
    ///   - target: Type of request and it's parameters if any.
    ///   - id: The unique identifier of the request (can be omitted).
    /// - Returns: The identifier of sent request, or nil if the request couldn't be sent.
    @discardableResult func send(_ target: WebOSTarget, id: String) -> String?

    @discardableResult func sendCustom(_ target: WebOSTarget, id: String) -> String?

    /// Sends a JSON-formatted request to the service.
    /// - Parameter jsonRequest: The JSON-formatted request to be sent.
    func send(jsonRequest: String)

    /// Sends a key press event to the service using the specified WebOSKeyTarget.
    /// - Parameter key: The target key to be pressed.
    func sendKey(_ key: WebOSKeyTarget)

    /// Sends a key press event to the WebOS service using the provided key data.
    /// - Parameter keyData: The key data to be sent as a key press event.
    func sendKey(keyData: Data)

    /// Sends a ping request to the service for maintaining the connection.
    func sendPing()

    /// Disconnects the WebOS client from the WebOS service.
    func disconnect()
}

extension WebOSClientProtocol {
    @discardableResult public func send(
        _ target: WebOSTarget,
        id: String = UUID().uuidString.lowercased()
    ) -> String? {
        send(target, id: id)
    }

    @discardableResult public func sendCustom(
        _ target: WebOSTarget,
        id: String = UUID().uuidString.lowercased()
    ) -> String? {
        sendCustom(target, id: id)
    }
}
