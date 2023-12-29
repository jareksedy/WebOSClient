//
//  WebOSKeyTargetExtension.swift
//  Created by Yaroslav Sedyshev on 18.12.2023.
//

import Foundation

extension WebOSKeyTarget: WebOSKeyTargetProtocol {
    var name: String {
        switch self {
        case .num0, .num1, .num2, .num3, .num4, .num5, .num6, .num7, .num8, .num9:
            return String(describing: self).last!.description
        default:
            return String(describing: self).uppercased()
        }
    }
    
    var request: Data? {
        switch self {
        case .move(let dx, let dy, let down):
            return "type:move\ndx:\(dx)\ndy:\(dy)\ndown:\(down)\n\n".data(using: .utf8)
        case .click:
            return "type:click\n\n".data(using: .utf8)
        case .scroll(let dx, let dy):
            return "type:scroll\ndx:\(dx)\ndy:\(dy)\n\n".data(using: .utf8)
        default:
            return "type:button\nname:\(name)\n\n".data(using: .utf8)
        }
    }
}
