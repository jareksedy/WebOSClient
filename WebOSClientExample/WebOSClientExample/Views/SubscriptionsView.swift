//
//  SubscriptionsView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 13.01.2024.
//

import SwiftUI

struct SubscriptionsView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            HStack {
                Text("CUR. APP ID: \((viewModel.foregroundApp).uppercased())")
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
                Text("VOLUME LVL.: \(String(Int(viewModel.volumeLevel)))")
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                Spacer()
                    .frame(width: 25)
                Slider(value: $viewModel.volumeLevel, in: 0...100, onEditingChanged: { editing in
                    if !editing {
                        viewModel.tv?.send(.setVolume(Int(viewModel.volumeLevel)))
                    }
                })
            }
            .padding()
        }
        .padding()
        .navigationTitle("WebOSClientExample App :: Subscriptions")
    }
}
