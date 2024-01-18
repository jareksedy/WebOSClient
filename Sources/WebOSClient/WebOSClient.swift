//
//  WebOSClient.swift
//  Created by Yaroslav Sedyshev on 29.11.2023.
//

import Foundation

public class WebOSClient: NSObject, WebOSClientProtocol {
    private var url: URL?
    private var urlSession: URLSession?
    private var primaryWebSocketTask: URLSessionWebSocketTask?
    private var secondaryWebSocketTask: URLSessionWebSocketTask?
    private var shouldPerformHeartbeat: Bool
    private var disconnectOnError: Bool
    private var heartbeatTimer: Timer?
    private var heartbeatTimeInterval: TimeInterval
    private var pointerRequestId: String?
    
    public weak var delegate: WebOSClientDelegate?
    
    required public init(
        url: URL?,
        delegate: WebOSClientDelegate? = nil,
        shouldPerformHeartbeat: Bool = true,
        heartBeatTimeInterval: TimeInterval = 10,
        disconnectOnError: Bool = true
    ) {
        self.url = url
        self.delegate = delegate
        self.shouldPerformHeartbeat = shouldPerformHeartbeat
        self.heartbeatTimeInterval = heartBeatTimeInterval
        self.disconnectOnError = disconnectOnError
        super.init()
    }
    
    public func connect() {
        guard let url else {
            assertionFailure("Invalid device URL. Terminating.")
            return
        }
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        connect(url, task: &primaryWebSocketTask)
    }
    
    @discardableResult
    public func send(_ target: WebOSTarget, id: String) -> String? {
        guard let jsonRequest = target.request.jsonWithId(id) else {
            return nil
        }
        let message = URLSessionWebSocketTask.Message.string(jsonRequest)
        sendURLSessionWebSocketTaskMessage(message, task: primaryWebSocketTask)
        return id
    }
    
    public func send(jsonRequest: String) {
        let message = URLSessionWebSocketTask.Message.string(jsonRequest)
        sendURLSessionWebSocketTaskMessage(message, task: primaryWebSocketTask)
    }
    
    public func sendKey(_ key: WebOSKeyTarget) {
        guard let request = key.request else {
            return
        }
        let message = URLSessionWebSocketTask.Message.data(request)
        sendURLSessionWebSocketTaskMessage(message, task: secondaryWebSocketTask)
    }
    
    public func sendKey(keyData: Data) {
        let message = URLSessionWebSocketTask.Message.data(keyData)
        sendURLSessionWebSocketTaskMessage(message, task: secondaryWebSocketTask)
    }
    
    public func sendPing() {
        sendPing(task: primaryWebSocketTask)
    }
    
    public func disconnect() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
        secondaryWebSocketTask?.cancel(with: .goingAway, reason: nil)
        primaryWebSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    deinit {
        disconnect()
    }
}

private extension WebOSClient {
    func connect(
        _ url: URL,
        task: inout URLSessionWebSocketTask?
    ) {
        task = urlSession?.webSocketTask(with: url)
        task?.resume()
        if shouldPerformHeartbeat {
            setupHeartbeat()
        }
    }
    
    func sendURLSessionWebSocketTaskMessage(
        _ message: URLSessionWebSocketTask.Message,
        task: URLSessionWebSocketTask?
    ) {
        task?.send(message) { [weak self] error in
            if let error {
                self?.delegate?.didReceiveNetworkError(error)
            }
        }
    }
    
    func sendPing(task: URLSessionWebSocketTask?) {
        task?.sendPing { [weak self] error in
            if let error {
                self?.delegate?.didReceiveNetworkError(error)
            }
        }
    }
    
    func listen(
        _ completion: @escaping (Result<WebOSResponse, Error>) -> Void
    ) {
        primaryWebSocketTask?.receive { [weak self] result in
            if case .success(let response) = result {
                self?.handle(response, completion: completion)
                self?.listen(completion)
            }
        }
    }
    
    func handle(
        _ response: URLSessionWebSocketTask.Message,
        completion: @escaping (Result<WebOSResponse, Error>) -> Void
    ) {
        if case .string(let jsonResponse) = response {
            delegate?.didReceive(jsonResponse: jsonResponse)
        }
        guard let response = response.decode(),
              let type = response.type,
              let responseType = WebOSResponseType(rawValue: type) else {
            completion(.failure(NSError(domain: "WebOSClient: Unkown response type.", code: 0)))
            return
        }
        switch responseType {
        case .error:
            let errorMessage = response.error ?? "WebOSClient: Unknown error."
            completion(.failure(NSError(domain: errorMessage, code: 0, userInfo: nil)))
        case .registered:
            if let clientKey = response.payload?.clientKey {
                delegate?.didRegister(with: clientKey)
                pointerRequestId = send(.getPointerInputSocket)
            }
            fallthrough
        default:
            if response.payload?.pairingType == .prompt {
                delegate?.didPrompt()
            }
            if let socketPath = response.payload?.socketPath,
               let url = URL(string: socketPath),
               response.id == pointerRequestId {
                connect(url, task: &secondaryWebSocketTask)
            }
            completion(.success(response))
        }
    }
    
    func setupHeartbeat() {
        guard heartbeatTimer == nil else {
            return
        }
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: heartbeatTimeInterval,
                                              repeats: true) { [weak self] _ in
            self?.sendPing(task: self?.secondaryWebSocketTask)
            self?.sendPing(task: self?.primaryWebSocketTask)
        }
        RunLoop.current.add(heartbeatTimer!, forMode: .common)
    }
}

extension WebOSClient: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        guard webSocketTask === primaryWebSocketTask else {
            return
        }
        delegate?.didConnect()
        listen { [weak self] result in
            self?.delegate?.didReceive(result)
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        delegate?.didReceiveNetworkError(error)
        if disconnectOnError {
            disconnect()
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        guard webSocketTask === primaryWebSocketTask else {
            return
        }
        delegate?.didDisconnect()
    }
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if challenge
            .protectionSpace
            .authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(
                .useCredential,
                URLCredential(trust: challenge.protectionSpace.serverTrust!)
            )
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
