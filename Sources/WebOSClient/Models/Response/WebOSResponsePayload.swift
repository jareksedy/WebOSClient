//
//  WebOSResponsePayload.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

public struct WebOSResponsePayload: Codable {
    let pairingType: String?
    let returnValue: Bool?
    let clientKey: String?
    let toastId: String?
    let callerId: String?
    let volume: Int?
    let soundOutput: String?
    let volumeStatus: WebOSResponseVolumeStatus?
    let muteStatus: Bool?
    let method: String?
    let state: String?
    let productName: String?
    let modelName: String?
    let swType: String?
    let majorVer: String?
    let minorVer: String?
    let country: String?
    let countryGroup: String?
    let deviceId: String?
    let authFlag: String?
    let ignoreDisable: String?
    let ecoInfo: String?
    let configKey: String?
    let languageCode: String?
    let subscribed: Bool?
    let applications: [WebOSResponseApplication]?
    let appId: String?
    let processId: String?
    let windowId: String?
    let id: String?
    let sessionId: String?
    let socketPath: String?
    let devices: [WebOSResponseDevice]?
    
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
