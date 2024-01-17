//
//  LogView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 13.01.2024.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            TextEditor(text: .constant(viewModel.log))
                .lineSpacing(4)
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .navigationTitle("WebOSClientExample App :: Logs")
    }
}

extension String {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self.data(using: .utf8)!, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
