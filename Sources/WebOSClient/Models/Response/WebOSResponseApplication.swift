//
//  WebOSResponseApplication.swift
//  Created by Yaroslav Sedyshev on 12.12.2023.
//

import Foundation

public struct WebOSResponseApplication: Codable, Identifiable {
    public let id: String?
    public let title: String?
    public let icon: String?
    public let folderPath: String?
    public let version: String?
    public let systemApp: Bool?
    public let visible: Bool?
    public let vendor: String?
    public let type: String?
}
