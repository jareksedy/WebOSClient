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

### Basic setup

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

### Client methods

```swift
public protocol WebOSClientProtocol {
    /// Establishes a connection to the TV.
    func connect()
    
    /// Sends a request to the specified WebOSTarget and returns the unique identifier of the request.
    /// - Parameters:
    ///   - target: Type of request and it's parameters if any.
    ///   - id: The unique identifier of the request (can be omitted).
    /// - Returns: The identifier of sent request, or nil if the request couldn't be sent.
    @discardableResult func send(_ target: WebOSTarget, id: String) -> String?
    
    /// Sends a key press event to the service using the specified WebOSKeyTarget.
    /// - Parameter key: The target key to be pressed.
    func sendKey(_ key: WebOSKeyTarget)
    
    /// Disconnects the WebOS client from the WebOS service.
    func disconnect()
}
```

### Delegate methods

```swift
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
    
    /// Invoked when the client encounters a network-related error, i.e. abnormal disconnect.
    /// - Parameter error: The error object representing the network error, if any.
    func didReceiveNetworkError(_ error: Error?)
    
    /// Invoked when the client disconnects from the WebOS websocket service.
    func didDisconnect()
}
```

### API commands

```swift
client?.send(.volumeUp)                             // Increases the volume by 1 unit.
client?.send(.volumeDown)                           // Decreases the volume by 1 unit.
client?.send(.getVolume(subscribe: true))           // Retrieves the current volume level with optional subscription.
client?.send(.setVolume(25))                        // Sets the volume to the specified level.
client?.send(.setMute(true))                        // Mutes or unmutes the audio.
client?.send(.play)                                 // Initiates playback.
client?.send(.pause)                                // Pauses the current media playback.
client?.send(.stop)                                 // Stops the current media playback.
client?.send(.rewind)                               // Rewinds the current media playback.
client?.send(.fastForward)                          // Fast-forwards the current media playback.
client?.send(.getSoundOutput(subscribe: true)       // Retrieves the current sound output with optional subscription.
client?.send(.changeSoundOutput(.soundbar))         // Changes the sound output to the specified type.
client?.send(.notify(message: "Hello, world!"))     // Shows a message on the screen.
client?.send(.screenOff)                            // Turns off the TV screen.
client?.send(.screenOn)                             // Turns on the TV screen.
client?.send(.systemInfo)                           // Retrieves system information.
client?.send(.turnOff)                              // Turns off the TV.
client?.send(.listApps)                             // Retrieves a list of installed apps.
client?.send(.getForegroundApp(subscribe: true))    // Retrieves the foreground app with optional subscription.
client?.send(.launchApp(appId: "netflix"))          // Launches an app with the specified ID, content ID, and parameters (optional).
client?.send(.closeApp(appId: "netflix"))           // Closes the app with the specified ID.
client?.send(.insertText(text: "text_to_insert"))   // Inserts text in the text input field with an optional replacement index (keyboard must be open).
client?.send(.sendEnterKey)                         // Sends an enter key press to the TV.
client?.send(.deleteCharacters(count: 1))           // Deletes a specified number of characters from the text input (keyboard must be open).
client?.send(.channelUp)                            // Increases the TV channel.
client?.send(.channelDown)                          // Decreases the TV channel.
client?.send(.listSources)                          // Retrieves a list of available input sources.
client?.send(.setSource("HDMI2"))                   // Sets the TV source to the specified input ID.
```
