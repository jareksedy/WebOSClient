//
//  String.swift
//  Created by Yaroslav Sedyshev on 05.12.2023.
//

import Foundation

extension String {
    func decode<T: Codable>() throws -> T {
        guard let data = self.data(using: .utf8) else {
            throw NSError(domain: "Invalid string encoding", code: 0, userInfo: nil)
        }
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw error
        }
    }
    
    var prettyPrinted: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            if var prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                prettyPrintedString = prettyPrintedString.replacingOccurrences(of: "\\/", with: "/")
                prettyPrintedString = prettyPrintedString.replacingOccurrences(of: "\\\"", with: "\"")
                return prettyPrintedString
            } else {
                return self
            }
        } catch {
            return self
        }
    }
}
