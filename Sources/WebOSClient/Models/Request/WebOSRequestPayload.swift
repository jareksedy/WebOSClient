//
//  WebOSRequestPayload.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

struct WebOSRequestPayload: Codable {
    var forcePairing: Bool?
    var manifest: WebOSRequestManifest?
    var pairingType: String?
    var clientKey: String?
    var message: String?
    var iconData: Data?
    var iconExtension: String?
    var volume: Int?
    var mute: Bool?
    var output: String?
    var standbyMode: String?
    var id: String?
    var contentId: String?
    var params: String?
    var sessionId: String?
    var text: String?
    var replace: Bool?
    var count: Int?
    var inputId: String?
    
    enum CodingKeys: String, CodingKey {
        case clientKey = "client-key"
        case forcePairing
        case manifest
        case pairingType
        case message
        case iconData
        case iconExtension
        case volume
        case mute
        case output
        case standbyMode
        case id
        case contentId
        case params
        case sessionId
        case text
        case replace
        case count
        case inputId
    }
}
