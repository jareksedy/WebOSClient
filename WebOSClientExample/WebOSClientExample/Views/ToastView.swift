//
//  ToastView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 14.01.2024.
//

import SwiftUI
import AppKit

struct ToastView: View {
    @State var toastText = "Enter your message here..."
    @ObservedObject var viewModel: ViewModel
    @FocusState var isTextEditorFocused: Bool
    var body: some View {
        VStack {
            Form {
                TextEditor(text: $toastText)
                    .lineSpacing(4)
                    .font(.title)
                    .focused($isTextEditorFocused)
                    .disabled(!viewModel.isConnected)
            }
            
            VStack {
                Button(action: {
                    viewModel.tv?.send(.notify(message: toastText))
                    isTextEditorFocused = true
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.title)
                    Text("Send Toast")
                        .font(.title)
                })
                .disabled(!viewModel.isConnected)
            }
            .frame(minHeight: 200)
        }
        .navigationTitle("WebOSClientExample App :: Toasts")
    }
}
