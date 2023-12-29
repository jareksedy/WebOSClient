//
//  Encodable+encode.swift
//  Created by Yaroslav Sedyshev on 18.12.2023.
//

import Foundation

extension Encodable {
    func encode() throws -> String {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(self)
            guard let json = String(data: encodedData, encoding: .utf8) else {
                throw NSError(domain: "Error encoding string", code: 0, userInfo: nil)
            }
            return json
        } catch {
            throw error
        }
    }
}
