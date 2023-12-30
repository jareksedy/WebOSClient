//
//  WebOSResponseVolumeStatus.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

public struct WebOSResponseVolumeStatus: Codable {
    public let volumeLimitable: Bool?
    public let activeStatus: Bool?
    public let maxVolume: Int?
    public let volumeLimiter: String?
    public let soundOutput: String?
    public let volume: Int?
    public let mode: String?
    public let externalDeviceControl: Bool?
    public let muteStatus: Bool?
    public let volumeSyncable: Bool?
    public let adjustVolume: Bool?
}
