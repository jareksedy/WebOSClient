//
//  WebOSRequestPayload.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

public struct WebOSRequestPayload: Codable {
    var pin: String?
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

    public init(
        pin: String? = nil,
        forcePairing: Bool? = nil,
        manifest: WebOSRequestManifest? = nil,
        pairingType: String? = nil,
        clientKey: String? = nil,
        message: String? = nil,
        iconData: Data? = nil,
        iconExtension: String? = nil,
        volume: Int? = nil,
        mute: Bool? = nil,
        output: String? = nil,
        standbyMode: String? = nil,
        id: String? = nil,
        contentId: String? = nil,
        params: String? = nil,
        sessionId: String? = nil,
        text: String? = nil,
        replace: Bool? = nil,
        count: Int? = nil,
        inputId: String? = nil
    ) {
        self.pin = pin
        self.forcePairing = forcePairing
        self.manifest = manifest
        self.pairingType = pairingType
        self.clientKey = clientKey
        self.message = message
        self.iconData = iconData
        self.iconExtension = iconExtension
        self.volume = volume
        self.mute = mute
        self.output = output
        self.standbyMode = standbyMode
        self.id = id
        self.contentId = contentId
        self.params = params
        self.sessionId = sessionId
        self.text = text
        self.replace = replace
        self.count = count
        self.inputId = inputId
    }

    public enum CodingKeys: String, CodingKey {
        case clientKey = "client-key"
        case pin
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
