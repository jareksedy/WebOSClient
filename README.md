# WebOSClient

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

WebOSClient is a Swift library that facilitates communication with LG TVs running WebOS. It provides a convenient way to connect to a TV, send commands, and handle various TV-related functionalities.

## Features

- Remote control a WebOS-based TV (LG Smart TVs).
- Handle TV events through subscriptions.

## Requirements

- iOS 13.0+, macOS 10.15+, watchOS 6.0+, tvOS 13.0+.

## Installation

Using Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/jareksedy/WebOSClient.git")
]
```

## Usage

Basic setup.

```swift
import UIKit
import WebOSClient

// MARK: - Constants
fileprivate enum Constants {
    static let registrationTokenKey = "clientKey"
}

// MARK: - ViewController
class ViewController: UIViewController {
    
    // The URL of the WebOS service on the TV.
    let url = URL(string: "wss://192.168.1.10:3001")
    
    // The client responsible for communication with the WebOS service.
    var client: WebOSClientProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate WebOSClient with the provided URL and set the current view controller as the delegate.
        client = WebOSClient(url: url, delegate: self)
        
        // Establish a connection to the TV.
        client?.connect()
        
        // Retrieve the registration token from UserDefaults.
        let registrationToken = UserDefaults.standard.string(forKey: Constants.registrationTokenKey)
        
        // Send a registration request to the TV with the stored or nil registration token.
        client?.send(.register(clientKey: registrationToken))
    }
}

// MARK: - WebOSClientDelegate
extension ViewController: WebOSClientDelegate {
    
    // Callback triggered upon successful registration with the TV.
    func didRegister(with clientKey: String) {
        
        // Store the received registration token in UserDefaults for future use.
        UserDefaults.standard.setValue(clientKey, forKey: Constants.registrationTokenKey)

        // Additional commands can be sent after successfull registration.
        client?.send(.volumeUp)
        client?.sendKey(.home)
    }
    

    // Callback triggered upon receiving a network error.
    func didReceiveNetworkError(_ error: Error?) {
        if let error = error as NSError? {
            
            // Print details of the received network error.
            print("Received network error. Code: \(error.code). Reconnect suggested.")
            
            // Attempt to reconnect and re-register with the TV.
            client?.connect()
            let registrationToken = UserDefaults.standard.string(forKey: Constants.registrationTokenKey)
            client?.send(.register(clientKey: registrationToken))
        }
    }
}
```
