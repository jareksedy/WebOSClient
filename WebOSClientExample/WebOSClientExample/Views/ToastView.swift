//
//  ToastView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 14.01.2024.
//

import SwiftUI
import AppKit

struct ToastView: View {
    @State var toastText = ""
    @ObservedObject var viewModel: ViewModel
    @FocusState var isTextEditorFocused: Bool
    var body: some View {
        VStack {
            HStack {
                TextField("Enter your message here...", text: $toastText)
                    .font(.title)
                    .focused($isTextEditorFocused)
                    .disabled(!viewModel.isConnected)
                
                Button(action: {
                    viewModel.tv?.send(.notify(message: toastText))
                    isTextEditorFocused = true
                    toastText = ""
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.title)
                    Text("Send Toast")
                        .font(.title)
                })
                .disabled(!viewModel.isConnected)
            }
            
            Text("Toast is an info alert that displays text message on the TV screen.\nIt gets dismissed automatically after a few seconds.")
                .multilineTextAlignment(.center)
                .padding(.top, 25)
        }
        .padding()
        .navigationTitle("WebOSClientExample App :: Toasts")
    }
}
