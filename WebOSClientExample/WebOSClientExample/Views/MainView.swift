//
//  MainView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 11.01.2024.
//

import SwiftUI

struct MainView: View {
    @State var selection: Int = 1
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                Section(header: Text("INFO")) {
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "info.bubble")
                    }
                    .tag(0)
                }
                Section(header: Text("MENU")) {
                    NavigationLink(destination: RemoteView(viewModel: viewModel)) {
                        Label("TV Remote", systemImage: "tv")
                    }
                    .tag(1)
                    NavigationLink(destination: MouseView(viewModel: viewModel)) {
                        Label("Mouse Pad", systemImage: "cursorarrow.click.2")
                    }
                    .tag(2)
                    NavigationLink(destination: Text("")) {
                        Label("Apps", systemImage: "apps.ipad.landscape")
                    }
                    .tag(3)
                    NavigationLink(destination: SubscriptionsView(viewModel: viewModel)) {
                        Label("Subscriptions", systemImage: "antenna.radiowaves.left.and.right")
                    }
                    .tag(4)
                    NavigationLink(destination: Text("")) {
                        Label("Toasts", systemImage: "text.bubble")
                    }
                    .tag(5)
                    NavigationLink(destination: LogView(viewModel: viewModel)) {
                        Label("Logs", systemImage: "folder.badge.gearshape")
                    }
                    .tag(6)
                }
                
                Section(header: Text("CONNECTION STATUS")) {
                    if viewModel.isConnected {
                        Label("Connected", systemImage: "tv")
                            .foregroundColor(.green)
                    } else {
                        Label("Disconnected", systemImage: "tv.slash")
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        if viewModel.isConnected {
                            viewModel.tv?.disconnect()
                        } else {
                            viewModel.connectAndRegister()
                        }
                    }, label: {
                        Image(systemName: viewModel.isConnected ? "tv.slash" : "tv")
                    })
                    .help(viewModel.isConnected ? "Disconnect" : "Connect")
                }
                if selection == 6 {
                    ToolbarItem(placement: .accessoryBar(id: 0)) {
                        Button(action: {
                            viewModel.log = ""
                        }, label: {
                            Image(systemName: "folder.badge.minus")
                            Text("Clear Logs")
                        })
                        .help("Clear Logs")
                    }
                }
                
            }
            .alert("Please accept registration prompt on the TV.",
                   isPresented: $viewModel.showPromptAlert) {
            }
        }
        .onAppEnteredForeground {
            viewModel.ping()
        }
    }
}

extension View {
    func onNotification(
        _ notificationName: Notification.Name,
        perform action: @escaping () -> Void
    ) -> some View {
        onReceive(NotificationCenter.default.publisher(
            for: notificationName
        )) { _ in
            action()
        }
    }
    
    func onAppEnteredBackground(
        perform action: @escaping () -> Void
    ) -> some View {
        onNotification(
            goDown,
            perform: action
        )
    }
    
    func onAppEnteredForeground(
        perform action: @escaping () -> Void
    ) -> some View {
        onNotification(
            goUp,
            perform: action
        )
    }
    
}

fileprivate let goDown = NSApplication.didResignActiveNotification
fileprivate let goUp = NSApplication.didBecomeActiveNotification
