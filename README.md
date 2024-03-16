# WebOSClient

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![SPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swiftpackageindex.com/exyte/ActivityIndicatorView)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/SVGView)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

WebOSClient is a Swift library that facilitates communication with LG TVs running WebOS. It provides a convenient way to connect to a TV, send commands, and handle various TV-related functionalities.

Please note that it's essential for this package to function, that the iOS device running it and the LG TV are both connected to the same WiFi network.

You'll need to manually enter the IP address of the LG TV for this package to operate. If you prefer to automatically discover devices on the network, I recommend utilizing the [SSDPClient package](https://github.com/pierrickrouxel/SSDPClient) (or similar).

## Features

- Remote control a WebOS-based TV (LG Smart TVs).
- Handle TV events through subscriptions.
- Handy example project demonstrating the library's core features.

## Requirements

- iOS 13.0+, macOS 10.15+, watchOS 6.0+, tvOS 13.0+, visionOS 1.0+.

## Installation

### Swift Package Manager

Adding WebOSClient as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/jareksedy/WebOSClient.git"))
]
```

### CocoaPods

To integrate WebOSClient into your Xcode project using CocoaPods, specify it in your Podfile:

```
pod 'WebOSClient'
```

## Version History

### 1.3.0. Minor improvements.
#### Features
* Make some of the internal properties public for convenience.

### 1.2.0. Minor improvements.
#### Features
* Make some of the internal properties public for convenience.

### 1.1.0. Minor improvements.
#### Features
* Minor improvements in WebOSClient.

### 1.0.9. Minor improvements in example project.
#### Features
* Changed app icon & other minor tweaks.

### 1.0.3. Example App
#### Features
* Added an option to enter IP manually in example project.
* Changed the example project icon.

### 1.0.0. Initial release
#### Features
* WebOSClient package.
* Example project demonstrating library's core functionalities.

## Usage

### Basic setup

Here's a basic example demonstrating the setup of WebOSClient and connection to the TV using UIKit.

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

These are the core methods of WebOSClient allowing connection with the TV and sending keys and various commands.

```swift
public protocol WebOSClientProtocol {
    /// Establishes a connection to the TV.
    func connect()
    
    /// Sends a specified request to the TV and returns the unique identifier of the request.
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

These are the methods for handling various WebOSClient events.

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

### Common API commands

These commands cover fundamental functionalities such as adjusting volume, retrieving current volume levels, muting or unmuting the audio, turning the TV screen off and on, etc.

```swift
client?.send(.volumeUp)                                                     // Increases the volume by 1 unit.
client?.send(.volumeDown)                                                   // Decreases the volume by 1 unit.
client?.send(.getVolume(subscribe: true))                                   // Retrieves the current volume level with optional subscription.
client?.send(.setVolume(25))                                                // Sets the volume to the specified level.
client?.send(.setMute(true))                                                // Mutes or unmutes the audio.
client?.send(.play)                                                         // Initiates playback.
client?.send(.pause)                                                        // Pauses the current media playback.
client?.send(.stop)                                                         // Stops the current media playback.
client?.send(.rewind)                                                       // Rewinds the current media playback.
client?.send(.fastForward)                                                  // Fast-forwards the current media playback.
client?.send(.getSoundOutput(subscribe: true))                              // Retrieves the current sound output with optional subscription.
client?.send(.changeSoundOutput(.soundbar))                                 // Changes the sound output to the specified type.
client?.send(.toast(message: "Hello, world!"))                              // Shows a message on the screen.
client?.send(.screenOff)                                                    // Turns off the TV screen.
client?.send(.screenOn)                                                     // Turns on the TV screen.
client?.send(.systemInfo)                                                   // Retrieves system information.
client?.send(.turnOff)                                                      // Turns off the TV.
client?.send(.listApps)                                                     // Retrieves a list of installed apps.
client?.send(.getForegroundApp(subscribe: true))                            // Retrieves the foreground app with optional subscription.
client?.send(.launchApp(appId: "netflix"))                                  // Launches an app with the specified ID, content ID, and parameters (optional).
client?.send(.closeApp(appId: "netflix"))                                   // Closes the app with the specified ID.
client?.send(.insertText(text: "text_to_insert", replace: Bool = true))     // Inserts text in the text input field (keyboard must be open). If 'replace' is true, replaces any existing text in field.
client?.send(.sendEnterKey)                                                 // Sends an enter key press to the TV.
client?.send(.deleteCharacters(count: 1))                                   // Deletes a specified number of characters from the text input (keyboard must be open).
client?.send(.channelUp)                                                    // Increases the TV channel.
client?.send(.channelDown)                                                  // Decreases the TV channel.
client?.send(.listSources)                                                  // Retrieves a list of available input sources.
client?.send(.setSource("HDMI2"))                                           // Sets the TV source to the specified input ID.
```

### Key API commands

These commands use a slightly different API and introduce a distinct set of functionalities, specifically tailored for simulating remote control key presses on LG TVs. 

```swift
client?.sendKey(.move(dx: 10, dy: 10))              // Simulates moving the mouse pointer on the screen.
client?.sendKey(.click)                             // Simulates mouse click action.
client?.sendKey(.scroll(dx: 0, dy: 100)             // Simulates scrolling on the screen.
client?.sendKey(.left)                              // Simulates a left arrow key press.
client?.sendKey(.right)                             // Simulates a right arrow key press.
client?.sendKey(.up)                                // Simulates an up arrow key press.
client?.sendKey(.down)                              // Simulates a down arrow key press.
client?.sendKey(.home)                              // Simulates a home button press.
client?.sendKey(.back)                              // Simulates a back button press.
client?.sendKey(.menu)                              // Simulates a menu button press.
client?.sendKey(.enter)                             // Simulates OK button press.
client?.sendKey(.dash)                              // Simulates a dash button press.
client?.sendKey(.info)                              // Simulates an info button press.
client?.sendKey(.num0)                              // Simulates pressing the number 0—9 key.
client?.sendKey(.asterisk)                          // Simulates pressing the asterisk key.
client?.sendKey(.cc)                                // Simulates pressing the closed caption (CC) key.
client?.sendKey(.exit)                              // Simulates an exit button press.
client?.sendKey(.mute)                              // Simulates a mute button press.
client?.sendKey(.red)                               // Simulates pressing the red color button.
client?.sendKey(.green)                             // Simulates pressing the green color button.
client?.sendKey(.yellow)                            // Simulates pressing the yellow color button.
client?.sendKey(.blue)                              // Simulates pressing the blue color button.
client?.sendKey(.volumeUp)                          // Simulates pressing the volume up button.
client?.sendKey(.volumeDown)                        // Simulates pressing the volume down button.
client?.sendKey(.channelUp)                         // Simulates pressing the channel up button.
client?.sendKey(.channelDown)                       // Simulates pressing the channel down button.
client?.sendKey(.play)                              // Simulates a play button press.
client?.sendKey(.pause)                             // Simulates a pause button press.
client?.sendKey(.stop)                              // Simulates a stop button press.
client?.sendKey(.rewind)                            // Simulates a rewind button press.
client?.sendKey(.fastForward)                       // Simulates a fast-forward button press.
```

## Documentation
 
Documentation is also provided in the source code. Check the comments in the respective files for more information. Refer to the example project that comes with this library for additional details.

## Example project

The accompanying example project included in this package showcases the library's fundamental features and serves as a demonstration of its core functionalities on macOS.

![Example App Screenshot](/Screenshots/WebOSClientExampleApp.png?raw=true)

## Contributing

Feel free to contribute to this library by submitting issues or pull requests. Your feedback and contributions are highly appreciated!

## License

This library is licensed under the MIT License. See the LICENSE file for details.
