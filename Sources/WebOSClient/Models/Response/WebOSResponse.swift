//
//  WebOSResponse.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

public struct WebOSResponse: Codable {
    public let type: String?
    public let id: String?
    public let error: String?
    public let payload: WebOSResponsePayload?
}
