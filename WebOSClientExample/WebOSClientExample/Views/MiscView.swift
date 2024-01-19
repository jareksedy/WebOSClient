//
//  MiscView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 16.01.2024.
//

import SwiftUI
import WebOSClient

struct MiscView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var screenOn: Bool = true
    var body: some View {
        VStack {
            Button(action: {
                viewModel.tv?.send(screenOn ? .screenOff : .screenOn)
                screenOn.toggle()
            }, label: {
                HStack {
                    Image(systemName: screenOn ? "sparkles.tv" : "sparkles.tv.fill")
                    Text(screenOn ? "Turn Screen Off" : "Turn Screen On")
                }
                .padding(10)
            })
            .disabled(!viewModel.isConnected)
            
            Button(action: {
                viewModel.tv?.send(.turnOff)
            }, label: {
                HStack {
                    Image(systemName: "power.circle.fill")
                        .foregroundColor(.accentColor)
                    Text("Power Off")
                }
                .padding(10)
            })
            .disabled(!viewModel.isConnected)
        }
        .navigationTitle("WebOSClientExample App :: Miscellaneous")
    }
}
