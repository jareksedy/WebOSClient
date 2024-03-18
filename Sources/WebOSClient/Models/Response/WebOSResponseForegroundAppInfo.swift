//
//  WebOSResponseForegroundAppInfo.swift
//  Created by Ярослав Седышев on 18.03.2024.
//

import Foundation

public struct WebOSResponseForegroundAppInfo: Codable {
    public let appId: String?
    public let mediaId: String?
    public let type: String?
    public let windowId: String?
    public let playState: String?
}
