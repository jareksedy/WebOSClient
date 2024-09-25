//
//  WebOSRequestManifest.swift
//  Created by Yaroslav Sedyshev on 06.12.2023.
//

import Foundation

public struct WebOSRequestManifest: Codable {
    var appVersion: String = "1.1"
    var manifestVersion: Int = 1
    var permissions: [String] = [
        "LAUNCH",
        "LAUNCH_WEBAPP",
        "APP_TO_APP",
        "CLOSE",
        "TEST_OPEN",
        "TEST_PROTECTED",
        "CONTROL_AUDIO",
        "CONTROL_DISPLAY",
        "CONTROL_INPUT_JOYSTICK",
        "CONTROL_INPUT_MEDIA_RECORDING",
        "CONTROL_INPUT_MEDIA_PLAYBACK",
        "CONTROL_INPUT_TV",
        "CONTROL_POWER",
        "READ_APP_STATUS",
        "READ_CURRENT_CHANNEL",
        "READ_INPUT_DEVICE_LIST",
        "READ_NETWORK_STATE",
        "READ_RUNNING_APPS",
        "READ_TV_CHANNEL_LIST",
        "WRITE_NOTIFICATION_TOAST",
        "READ_POWER_STATE",
        "READ_COUNTRY_INFO",
        "READ_SETTINGS",
        "CONTROL_TV_SCREEN",
        "CONTROL_TV_STANBY",
        "CONTROL_FAVORITE_GROUP",
        "CONTROL_USER_INFO",
        "CHECK_BLUETOOTH_DEVICE",
        "CONTROL_BLUETOOTH",
        "CONTROL_TIMER_INFO",
        "STB_INTERNAL_CONNECTION",
        "CONTROL_RECORDING",
        "READ_RECORDING_STATE",
        "WRITE_RECORDING_LIST",
        "READ_RECORDING_LIST",
        "READ_RECORDING_SCHEDULE",
        "WRITE_RECORDING_SCHEDULE",
        "READ_STORAGE_DEVICE_LIST",
        "READ_TV_PROGRAM_INFO",
        "CONTROL_BOX_CHANNEL",
        "READ_TV_ACR_AUTH_TOKEN",
        "READ_TV_CONTENT_STATE",
        "READ_TV_CURRENT_TIME",
        "ADD_LAUNCHER_CHANNEL",
        "SET_CHANNEL_SKIP",
        "RELEASE_CHANNEL_SKIP",
        "CONTROL_CHANNEL_BLOCK",
        "DELETE_SELECT_CHANNEL",
        "CONTROL_CHANNEL_GROUP",
        "SCAN_TV_CHANNELS",
        "CONTROL_TV_POWER",
        "CONTROL_WOL",
    ]
    var signatures: [WebOSRequestSignature] = [WebOSRequestSignature()]
    var signed: WebOSRequestSigned = WebOSRequestSigned()
}
