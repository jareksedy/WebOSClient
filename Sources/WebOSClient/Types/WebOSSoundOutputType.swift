//
//  WebOSSoundOutputType.swift
//  Created by Yaroslav Sedyshev on 10.12.2023.
//

import Foundation

public enum WebOSSoundOutputType: String {
    case tvSpeaker
    case externalSpeaker
    case soundbar
    case btSoundbar
    case tvExternalSpeaker
    
    enum CodingKeys: String, CodingKey {
        case tvSpeaker = "tv_speaker"
        case externalSpeaker = "external_speaker"
        case soundbar
        case btSoundbar = "bt_soundbar"
        case tvExternalSpeaker = "tv_external_speaker"
    }
}
