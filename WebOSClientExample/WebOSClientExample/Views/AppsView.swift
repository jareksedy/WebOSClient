//
//  AppsView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 15.01.2024.
//

import SwiftUI
import WebOSClient

struct AppsView: View {
    var grid = Array(repeating: GridItem(.fixed(100)), count: 6)
    @ObservedObject var viewModel: ViewModel
    @State private var hoveredId: String?
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid) {
                ForEach(viewModel.apps) { app in
                    GridItemView(app: app, isHovered: app.id == hoveredId)
                        .onHover { isHovered in
                            hoveredId = isHovered ? app.id : nil
                        }
                        .onTapGesture {
                            if let id = app.id {
                                viewModel.tv?.send(.launchApp(appId: id))
                            }
                        }
                }
            }
            .padding()
        }
        .opacity(viewModel.isConnected ? 1 : 0.25)
        .navigationTitle("WebOSClientExample App :: Installed Apps")
    }
}

struct GridItemView: View {
    let app: WebOSResponseApplication
    let isHovered: Bool
    
    var body: some View {
        VStack {
            Text(app.title ?? "N/A")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(.gray.opacity(isHovered ? 0.2 : 0.1))
        .cornerRadius(12)
    }
}
