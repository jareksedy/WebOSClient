//
//  AppsView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 15.01.2024.
//

import SwiftUI

struct AppsView: View {
    var grid = Array(repeating: GridItem(.fixed(100)), count: 6)
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid) {
                ForEach(viewModel.apps) { app in
                    VStack {
                        Text(app.title ?? "N/A")
                    }
                    .frame(width: 100, height: 100)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                    .onTapGesture {
                        if let id = app.id {
                            viewModel.tv?.send(.launchApp(appId: id))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("WebOSClientExample App :: Installed Apps")
    }
}
