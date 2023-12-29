//
//  WebOSResponseDevice.swift
//  Created by Yaroslav Sedyshev on 23.12.2023.
//

import Foundation

struct WebOSResponseDevice: Codable {
    let id: String?
    let label: String?
    let port: Int?
    let connected: Bool?
    let appId: String?
    let icon: String?
    let forceIcon: Bool?
    let modified: Bool?
    let lastUniqueId: Int?
    let hdmiPlugIn: Bool?
    let subCount: Int?
    let favorite: Bool?
}
