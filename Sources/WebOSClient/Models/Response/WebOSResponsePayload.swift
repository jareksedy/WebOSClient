//
//  WebOSResponsePayload.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

public struct WebOSResponsePayload: Codable {
    public let pairingType: String?
    public let returnValue: Bool?
    public let clientKey: String?
    public let toastId: String?
    public let callerId: String?
    public let volume: Int?
    public let soundOutput: String?
    public let volumeStatus: WebOSResponseVolumeStatus?
    public let muteStatus: Bool?
    public let method: String?
    public let state: String?
    public let productName: String?
    public let modelName: String?
    public let swType: String?
    public let majorVer: String?
    public let minorVer: String?
    public let country: String?
    public let countryGroup: String?
    public let deviceId: String?
    public let authFlag: String?
    public let ignoreDisable: String?
    public let ecoInfo: String?
    public let configKey: String?
    public let languageCode: String?
    public let subscribed: Bool?
    public let applications: [WebOSResponseApplication]?
    public let appId: String?
    public let processId: String?
    public let windowId: String?
    public let id: String?
    public let sessionId: String?
    public let socketPath: String?
    public let devices: [WebOSResponseDevice]?
    
    enum CodingKeys: String, CodingKey {
        case pairingType
        case returnValue
        case clientKey = "client-key"
        case toastId
        case callerId
        case volume
        case soundOutput
        case volumeStatus
        case muteStatus
        case method
        case state
        case productName = "product_name"
        case modelName = "model_name"
        case swType = "sw_type"
        case majorVer = "major_ver"
        case minorVer = "minor_ver"
        case country
        case countryGroup = "country_group"
        case deviceId = "device_id"
        case authFlag = "auth_flag"
        case ignoreDisable = "ignore_disable"
        case ecoInfo = "eco_info"
        case configKey = "config_key"
        case languageCode = "language_code"
        case subscribed
        case applications = "apps"
        case appId
        case processId
        case windowId
        case id
        case sessionId
        case socketPath
        case devices
    }
}
