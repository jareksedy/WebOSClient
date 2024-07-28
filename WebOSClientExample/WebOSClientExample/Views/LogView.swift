//
//  LogView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 13.01.2024.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var logCapture: LogCapture
    @State private var logContent: String = ""
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    TextEditor(text: .constant(logContent))
                        .lineSpacing(4)
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .id("TEXT_EDITOR")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onChange(of: logCapture.logOutput) { newValue in
                            logContent = newValue
                            withAnimation {
                                scrollViewProxy.scrollTo("TEXT_EDITOR", anchor: .bottom)
                            }
                        }
                }
            }
        }
        .navigationTitle("WebOSClientExample App :: Logs")
    }
}
