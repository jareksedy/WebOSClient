//
//  SubscriptionsView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 13.01.2024.
//

import SwiftUI

struct SubscriptionsView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("CUR. APP ID: \((viewModel.foregroundApp).uppercased())")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
            }
            .padding()
            
            HStack {
                Text("CUR. APP PLAYSTATE: \((viewModel.currentPlayState).uppercased())")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
            }
            .padding()
            
            HStack {
                Text("CUR. OUTPUT: \((viewModel.soundOutput?.rawValue ?? "N/A").uppercased())")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
            }
            .padding()
            
            HStack {
                Text("CUR. TEXTFIELD. FOCUSED: \(String(describing: viewModel.currentTextField?.focus ?? false).uppercased()). HAS TEXT: \(String(describing: viewModel.currentTextField?.hasSurroundingText ?? false).uppercased())")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
            }
            .padding()
            
            HStack {
                Text("VOLUME LVL.: \(String(Int(viewModel.volumeLevel)))")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
                    .frame(width: 25)
                Slider(value: $viewModel.volumeLevel, in: 0...100, onEditingChanged: { editing in
                    if !editing {
                        viewModel.tv?.send(.setVolume(Int(viewModel.volumeLevel)))
                    }
                })
                .disabled(!viewModel.isConnected)
            }
            .padding()
            Spacer()
                .frame(height: 25)
            Text("Subscriptions represent a potent mechanism enabling you to observe specific changes in the state of a WebOS. Please be aware that older versions of WebOS may not support subscriptions or may exhibit different response outputs.")
                .multilineTextAlignment(.center)
                .padding(.leading, 25)
                .padding(.trailing, 25)
            Spacer()
        }
        .opacity(viewModel.isConnected ? 1 : 0.5)
        .padding()
        .navigationTitle("WebOSClientExample App :: Subscriptions")
    }
}
