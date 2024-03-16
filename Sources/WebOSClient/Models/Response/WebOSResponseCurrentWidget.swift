//
//  WebOSResponseCurrentWidget.swift
//  Created by Ярослав Седышев on 16.03.2024.
//

import Foundation

public struct WebOSResponseCurrentWidget: Codable {
    public let focus: Bool?
    public let hasSurroundingText: Bool?
    public let contentType: String?
    public let cursorPosition: Int?
    public let correctionEnabled: Bool?
    public let autoCapitalizationEnabled: Bool?
    public let enterKeyType: Int?
    public let hiddenText: Bool?
    public let predictionEnabled: Bool?
    public let surroundingTextLength: Int?
}
