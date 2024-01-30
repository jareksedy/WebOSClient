//
//  WebOSKeyTarget.swift
//  Created by Yaroslav Sedyshev on 18.12.2023.
//

import Foundation

/// Enum defining various remote control keys for communication with LG TVs.
public enum WebOSKeyTarget: WebOSKeyTargetProtocol {
    /// Simulates moving the pointer on the screen.
    /// - Parameters:
    ///   - dx: The change in the x-coordinate (horizontal movement).
    ///   - dy: The change in the y-coordinate (vertical movement).
    case move(dx: Int, dy: Int, down: Int = 0)
    
    /// Simulates a click action.
    case click
    
    /// Simulates scrolling on the screen.
    /// - Parameters:
    ///   - dx: The change in the x-coordinate (horizontal scroll).
    ///   - dy: The change in the y-coordinate (vertical scroll).
    case scroll(dx: Int, dy: Int)
    
    /// Simulates a left arrow key press.
    case left
    
    /// Simulates a right arrow key press.
    case right
    
    /// Simulates an up arrow key press.
    case up
    
    /// Simulates a down arrow key press.
    case down
    
    /// Simulates a home button press.
    case home
    
    /// Simulates a back button press.
    case back
    
    /// Simulates a menu button press.
    case menu
    
    /// Simulates an enter or OK button press.
    case enter
    
    /// Simulates a dash (-) button press.
    case dash
    
    /// Simulates an info button press.
    case info
    
    /// Simulates pressing the number 1 key.
    case num1
    
    /// Simulates pressing the number 2 key.
    case num2
    
    /// Simulates pressing the number 3 key.
    case num3
    
    /// Simulates pressing the number 4 key.
    case num4
    
    /// Simulates pressing the number 5 key.
    case num5
    
    /// Simulates pressing the number 6 key.
    case num6
    
    /// Simulates pressing the number 7 key.
    case num7
    
    /// Simulates pressing the number 8 key.
    case num8
    
    /// Simulates pressing the number 9 key.
    case num9
    
    /// Simulates pressing the number 0 key.
    case num0
    
    /// Simulates pressing the asterisk (*) key.
    case asterisk
    
    /// Simulates pressing the closed caption (CC) key.
    case cc
    
    /// Simulates an exit button press.
    case exit
    
    /// Simulates a mute button press.
    case mute
    
    /// Simulates pressing the red color button.
    case red
    
    /// Simulates pressing the green color button.
    case green
    
    /// Simulates pressing the yellow color button.
    case yellow
    
    /// Simulates pressing the blue color button.
    case blue
    
    /// Simulates pressing the volume up button.
    case volumeUp
    
    /// Simulates pressing the volume down button.
    case volumeDown
    
    /// Simulates pressing the channel up button.
    case channelUp
    
    /// Simulates pressing the channel down button.
    case channelDown
    
    /// Simulates a play button press.
    case play
    
    /// Simulates a pause button press.
    case pause
    
    /// Simulates a stop button press.
    case stop
    
    /// Simulates a rewind button press.
    case rewind
    
    /// Simulates a fast-forward button press.
    case fastForward
}
