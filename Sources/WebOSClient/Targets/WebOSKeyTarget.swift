//
//  WebOSKeyTarget.swift
//  Created by Yaroslav Sedyshev on 18.12.2023.
//

import Foundation

public 
enum WebOSKeyTarget {
    case move(dx: Int, dy: Int, down: Int = 0)
    case click
    case scroll(dx: Int, dy: Int)
    case left
    case right
    case up
    case down
    case home
    case back
    case menu
    case enter
    case dash
    case info
    case num1
    case num2
    case num3
    case num4
    case num5
    case num6
    case num7
    case num8
    case num9
    case num0
    case asterisk
    case cc
    case exit
    case mute
    case red
    case green
    case yellow
    case blue
    case volumeUp
    case volumeDown
    case channelUp
    case channelDown
    case play
    case pause
    case stop
    case rewind
    case fastForward
}
