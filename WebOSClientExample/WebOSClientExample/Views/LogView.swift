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
            TextEditor(text: .constant(viewModel.logOutput))
                .lineSpacing(4)
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .navigationTitle("WebOSClientExample App :: Logs")
    }
}
