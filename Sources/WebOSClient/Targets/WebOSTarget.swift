//
//  WebOSTarget.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

/// Enum defining various WebOS targets for communication with LG TVs.
public enum WebOSTarget {
    /// Registers the client with an optional client key.
    /// - Parameters:
    ///   - pairingType: The optional pairing type option either set to .prompt or .pin, default value is .prompt.
    ///   - clientKey: The optional client key for registration. If nil, prompt (or pin) to register appears on TV screen.
    case register(pairingType: WebOSPairingType = .prompt, clientKey: String? = nil)
    
    /// Sets the PIN code for pairing with the TV.
    /// - Parameter pin: The PIN code displayed on the TV for pairing.
    case setPin(_ pin: String)
    
    /// Increases the volume.
    case volumeUp
    
    /// Decreases the volume.
    case volumeDown
    
    /// Retrieves the current volume level with optional subscription.
    /// - Parameter subscribe: If true, subscribes to volume changes; if false, unsubscribes from volume changes; If nil, retrieves current volume level.
    case getVolume(subscribe: Bool? = nil)
    
    /// Sets the volume to the specified level.
    /// - Parameter level: The desired volume level to set 0 to 100.
    case setVolume(_ level: Int)
    
    /// Mutes or unmutes the audio.
    /// - Parameter mute: If true, mutes the audio; if false, unmutes the audio.
    case setMute(_ mute: Bool)
    
    /// Initiates playback.
    case play
    
    /// Pauses the current media playback.
    case pause
    
    /// Stops the current media playback.
    case stop
    
    /// Rewinds the current media playback.
    case rewind
    
    /// Fast-forwards the current media playback.
    case fastForward
    
    /// Retrieves the current sound output with optional subscription.
    /// - Parameter subscribe: If true, subscribes to sound output changes; if false, unsubscribes from sound output changes;
    case getSoundOutput(subscribe: Bool? = nil)
    
    /// Changes the sound output to the specified type.
    /// - Parameter type: The desired sound output type. See WebOSSoundOutputType.
    case changeSoundOutput(_ type: WebOSSoundOutputType)
    
    /// Shows a message on the screen, an optional icon data, and icon extension.
    /// - Parameters:
    ///   - message: The message to be displayed on the TV.
    ///   - iconData: Optional icon data to be displayed along with the message.
    ///   - iconExtension: Optional extension specifying the format of the icon data.
    case toast(message: String, iconData: Data? = nil, iconExtension: String? = nil)
    
    /// Turns off the TV screen.
    case screenOff
    
    /// Turns on the TV screen.
    case screenOn
    
    /// Retrieves system information.
    case systemInfo
    
    /// Turns off the TV.
    case turnOff
    
    /// Retrieves a list of installed apps.
    case listApps
    
    /// Retrieves the foreground app with optional subscription.
    /// - Parameter subscribe: If true, subscribes to foreground app changes; if false, unsubscribes from foreground app changes; if nil, no subscription.
    case getForegroundApp(subscribe: Bool? = nil)
    
    /// Retrieves the foreground app with media status updates.
    /// - Parameter subscribe: If true, subscribes to foreground app changes; if false, unsubscribes from foreground app changes; if nil, no subscription.
    case getForegroundAppMediaStatus(subscribe: Bool? = nil)
    
    /// Launches an app with the specified ID, content ID, and parameters.
    /// - Parameters:
    ///   - appId: The ID of the app to be launched.
    ///   - contentId: Optional content ID associated with the app.
    ///   - params: Optional parameters to be passed to the app.
    case launchApp(appId: String, contentId: String? = nil, params: String? = nil)
    
    /// Closes the app with the specified ID and optional session ID.
    /// - Parameters:
    ///   - appId: The ID of the app to be closed.
    ///   - sessionId: Optional session ID associated with the app.
    case closeApp(appId: String, sessionId: String? = nil)
    
    /// Inserts text in the text input field with an optional replacement index (keyboard must be open).
    /// - Parameters:
    ///   - text: The text to be inserted.
    ///   - replace: if true, replace any existing text in field.
    case insertText(text: String, replace: Bool = true)
    
    /// Sends an enter key press to the TV.
    case sendEnterKey
    
    /// Deletes a specified number of characters from the text input.
    /// - Parameter count: The number of characters to be deleted.
    case deleteCharacters(count: Int = 1)
    
    /// Allows subscribing to information about the current text field.
    case registerRemoteKeyboard
    
    /// Retrieves the input socket for pointer input. This is sent automatically once the client gets registered.
    case getPointerInputSocket
    
    /// Increases the TV channel.
    case channelUp
    
    /// Decreases the TV channel.
    case channelDown
    
    /// Retrieves a list of available sources.
    case listSources
    
    /// Sets the TV source to the specified input ID.
    /// - Parameter inputId: The ID of the input source to be set.
    case setSource(_ inputId: String)
}
