# WebOSClient

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/)
[![SPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swiftpackageindex.com/exyte/ActivityIndicatorView)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/SVGView)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

WebOSClient is a Swift library designed to facilitate communication with Smart TVs running WebOS, such as LG TVs. It provides a convenient interface to connect to the TV, send commands, and manage various TV-related functionalities.

To use this package, ensure that both the client device and the TV are connected to the same Wi-Fi network.

#### Manual IP Entry

You will need to manually enter the IP address of the TV for this package to operate. To automatically discover devices on LAN, consider using the [SSDPClient package](https://github.com/pierrickrouxel/SSDPClient) package or a similar tool.

## Features

- Remote control a WebOS-based TV (LG Smart TV).
- Handle TV events through subscriptions.
- Handy example project demonstrating the library's core features.

## Requirements

- iOS 13.0+, macOS 10.15+, watchOS 6.0+, tvOS 13.0+, visionOS 1.0+.

## Installation

### Swift Package Manager

To add WebOSClient as a dependency, include it in the dependencies value of your Package.swift:

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

### 1.5.1 - Power State Subscription

#### Features

- Introduced `getPowerState(subscribe: Bool? = nil)` method to enable power state subscriptions.

Refer to [CHANGELOG.md](CHANGELOG.md) for the complete version history.

## Usage

### Basic Setup

Below is a basic example demonstrating the setup of WebOSClient and connection to the TV.

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
    let url = URL(string: "wss://192.168.1.10:3001")!

    // The client responsible for communication with the WebOS service.
    var client: WebOSClientProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate WebOSClient with the specified URL and set the current view controller as the delegate.
        // Enable activity logging by setting shouldLogActivity to true.
        client = WebOSClient(url: url, delegate: self, shouldLogActivity: true)

        // Establish a connection to the TV.
        client?.connect()

        // Retrieve the registration token from UserDefaults.
        let registrationToken = UserDefaults.standard.string(forKey: Constants.registrationTokenKey)

        // Send a registration request to the TV with the stored or nil registration token.
        // The PairingType option should be set to .pin for PIN-based pairing. The default value is .prompt.
        client?.send(.register(pairingType: .pin, clientKey: registrationToken))
    }
}

// MARK: - WebOSClientDelegate
extension ViewController: WebOSClientDelegate {
    // Callback triggered upon displaying the PIN to the user.
    func didDisplayPin() {
        // Send the correct PIN displayed on the TV screen to the TV here.
        client?.send(.setPin("12345678"))
    }

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

### Client Methods

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

### Delegate Methods

These are the methods for handling various WebOSClient events.

```swift
public protocol WebOSClientDelegate: AnyObject {
    /// Invoked when the client successfully establishes a connection.
    func didConnect()

    /// Invoked when the TV displays a PIN code for pairing.
    func didDisplayPin()

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

### Handling Pairing Errors

Handle pairing errors gracefully by notifying the user and offering options to retry or troubleshoot the connection. Capture pairing errors in the `didReceive` delegate method.

```swift
// MARK: - WebOSClientDelegate
extension ViewController: WebOSClientDelegate {
    func didReceive(_ result: Result<WebOSResponse, Error>) {
        if case .failure(let error) = result {
            let errorMessage = error.localizedDescription

            if errorMessage.contains("rejected pairing") {
            // Pairing rejected by the user or invalid pin.
            }

            if errorMessage.contains("cancelled") {
            // Pairing cancelled due to a timeout.
            }
        }
    }
}
```

### Common API Commands

These commands cover fundamental functionalities such as adjusting volume, retrieving current volume levels, muting or unmuting the audio, turning the TV screen off and on, etc.

```swift
client?.send(.setPin("12345678"))                                           // Sets the PIN for pairing.
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
client?.send(.getPowerState(subscribe: true))                               // Retrieves the TV power state (on/off) with optional subscription.
client?.send(.screenOff)                                                    // Turns off the TV screen.
client?.send(.screenOn)                                                     // Turns on the TV screen.
client?.send(.systemInfo)                                                   // Retrieves system information.
client?.send(.turnOff)                                                      // Turns off the TV.
client?.send(.listApps)                                                     // Retrieves a list of installed apps.
client?.send(.getForegroundApp(subscribe: true))                            // Retrieves the foreground app with optional subscription.
client?.send(.getForegroundAppMediaStatus(subscribe: true))                 // Retrieves the foreground app with media status with optional subscription.
client?.send(.getPictureSettings(subscribe: true))                          // Retrieves the picture setting (color, brightness, backlight, contrast). Only tested on > 2022 models.
client?.send(.getSoundMode(subscribe: true))                                // Retrieves the sound mode. Available sound modes (not all are available on all TVs): aiSoundPlus, standard, movie, news, sports, music, game.
client?.send(.launchApp(appId: "netflix"))                                  // Launches an app with the specified ID, content ID, and parameters (optional).
client?.send(.closeApp(appId: "netflix"))                                   // Closes the app with the specified ID.
client?.send(.insertText(text: "text_to_insert", replace: Bool = true))     // Inserts text in the text input field (keyboard must be open). If 'replace' is true, replaces any existing text in field.
client?.send(.sendEnterKey)                                                 // Sends an enter key press to the TV.
client?.send(.deleteCharacters(count: 1))                                   // Deletes a specified number of characters from the text input (keyboard must be open).
client?.send(.registerRemoteKeyboard)                                       // Subscribes to current text field changes.
client?.send(.channelUp)                                                    // Increases the TV channel.
client?.send(.channelDown)                                                  // Decreases the TV channel.
client?.send(.listSources)                                                  // Retrieves a list of available input sources.
client?.send(.setSource("HDMI2"))                                           // Sets the TV source to the specified input ID.
```

### Subscriptions

The following commands allow you to continuously monitor changes in the TV’s state and react accordingly within your app.

```swift
client?.send(.getPowerState(subscribe: true))                               // Retrieves the TV power state (on/off) with optional subscription.
client?.send(.getForegroundApp(subscribe: true))                            // Retrieves the foreground app with optional subscription.
client?.send(.getForegroundAppMediaStatus(subscribe: true))                 // Retrieves the foreground app with media status with optional subscription.
client?.send(.getVolume(subscribe: true))                                   // Retrieves the current volume level with optional subscription.
client?.send(.getSoundOutput(subscribe: true))                              // Retrieves the current sound output with optional subscription.
```

If subscribe flag is set to true, the client subscribes to continuous updates. If set to false, it unsubscribes from updates. If subscribe is nil, the client will retrieve the current state once without subscribing.

```swift
// Subscribe to volume changes.
var volumeSubscriptionId: String = ""
volumeSubscriptionId = client?.send(.getVolume(subscribe: true))
```

Receive state changes in the `didReceive` delegate method.

```swift
// MARK: - WebOSClientDelegate
extension ViewController: WebOSClientDelegate {
    func didReceive(_ result: Result<WebOSResponse, Error>) {
            if case .success(let response) = result, response.id == volumeSubscriptionId {
                dump(response)
            }
        }
    }
```

### Key API Commands

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

### LUNA API Commands

This is an tricky & indirect method to communicate with LUNA API which internally used by tv's apps (you can find more here: https://webostv.developer.lge.com/develop/references/luna-service-introduction). Basically, the LUNA request payload is embeded into an Alert request which will be sent to TV, when the Alert is pop out, the LUNA request payload will be triggered. Thus, it's up to your usecase whether you want to let user manually click "Ok" on the screen or automatically send key "Ok" upon Alert sucessfully show.

```swift
client?.sendLuna(.setPictureSettings(brightness: 100, contrast: 100, color: 100, backlight: 100))              // Set picture settings
client?.sendLuna(.setPictureMode(mode: "cinema"))                              /*
    Set Available picture modes (not all are available on all TVs):
    cinema, eco, expert1, expert2, game, normal, photo, sports, technicolor,
    vivid, hdrEffect,  hdrCinema, hdrCinemaBright, hdrExternal, hdrGame,
    hdrStandard, hdrTechnicolor, hdrVivid, dolbyHdrCinema,dolbyHdrCinemaBright,
    dolbyHdrDarkAmazon, dolbyHdrGame, dolbyHdrStandard, dolbyHdrVivid, dolbyStandard
    */
client?.sendLuna(.setSoundMode(value: "sports"))             /*
    Set Available sound modes (not all are available on all TVs):
    aiSoundPlus, standard, movie, news, sports, music, game
    */
```

Here is guideline how to automatically send key "Ok" upon showing Alert

```swift
// MARK: - WebOSClientDelegate
extension ViewController: WebOSClientDelegate {
    func didReceive(jsonResponse: String) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
            // Handle Luna
            if let id = jsonObject["id"] as? String {
                if let _ = ButtonGeometry.allCases.first(where: { $0.rawValue == id }) {
                    // Enter
                    client.sendKey(.enter)
                }
            }
        }
    }
}
```

## Documentation

Documentation is also provided in the source code. Check the comments in the respective files for more information. Refer to the example project that comes with this library for additional details.

## Example App

The accompanying example app included in this package showcases the library's fundamental features and serves as a demonstration of its core functionalities on macOS.

![Example App Screenshot](/Screenshots/WebOSClientExampleApp.png?raw=true)

## Contributing

Feel free to contribute to this library by submitting issues or pull requests. Your feedback and contributions are highly appreciated!

## License

This library is licensed under the MIT License. See the LICENSE file for details.
