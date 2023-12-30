//
//  WebOSResponseDevice.swift
//  Created by Yaroslav Sedyshev on 23.12.2023.
//

import Foundation

public struct WebOSResponseDevice: Codable {
    public let id: String?
    public let label: String?
    public let port: Int?
    public let connected: Bool?
    public let appId: String?
    public let icon: String?
    public let forceIcon: Bool?
    public let modified: Bool?
    public let lastUniqueId: Int?
    public let hdmiPlugIn: Bool?
    public let subCount: Int?
    public let favorite: Bool?
}
