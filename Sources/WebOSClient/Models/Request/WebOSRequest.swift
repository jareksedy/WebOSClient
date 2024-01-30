//
//  WebOSRequest.swift
//  Created by Yaroslav Sedyshev on 02.12.2023.
//

import Foundation

struct WebOSRequest: Codable {
    var type: String
    var id: String?
    var uri: String?
    var payload: WebOSRequestPayload?
    
    init(
        type: WebOSRequestType,
        id: String? = nil,
        uri: String? = nil,
        payload: WebOSRequestPayload? = nil
    ) {
        self.type = type.rawValue
        self.id = id
        self.uri = uri
        self.payload = payload
    }
    
    public func jsonWithId(_ id: String) -> String? {
        var copy = self
        copy.id = id
        do {
            return try copy.encode()
        } catch {
            print("Error encoding JSON: \(error)")
        }
        return nil
    }
}
