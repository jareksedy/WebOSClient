//
//  WebOSTargetProtocol.swift
//  Created by Yaroslav Sedyshev on 09.12.2023.
//

import Foundation

protocol WebOSTargetProtocol {
    var uri: String? { get }
    var request: WebOSRequest { get }
    var customRequest: WebOSCustomRequest { get }
}
