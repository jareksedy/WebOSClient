//
//  KeyboardView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 16.03.2024.
//

import SwiftUI

struct KeyboardView: View {
    @State var textToInsert = ""
    @ObservedObject var viewModel: ViewModel
    @FocusState var isTextEditorFocused: Bool
    var body: some View {
        VStack {
            HStack {
                TextField("Enter your text...", text: $textToInsert)
                    .font(.title)
                    .focused($isTextEditorFocused)
                    .disabled(!viewModel.isConnected)
                    .onChange(of: textToInsert) { _ in
                        viewModel.tv?.send(.insertText(text: textToInsert, replace: true))
                    }
                    
                Button(action: {
                    viewModel.tv?.send(.sendEnterKey)
                    isTextEditorFocused = true
                    textToInsert = ""
                }, label: {
                    HStack {
                        Text("Enter")
                    }
                    .padding(5)
                })
                .disabled(!viewModel.isConnected)
            }
            
            Text("Send keyboard input to the TV.\nMake sure that virtual keyboard on the TV is open.")
                .multilineTextAlignment(.center)
                .padding(.top, 25)
        }
        .padding()
        .navigationTitle("WebOSClientExample App :: Keyboard")
    }
}
