//
//  MainView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 11.01.2024.
//

import SwiftUI

struct MainView: View {
    @State var selection: Set<Int> = [0]
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                Section(header: Text("MAIN MENU")) {
                    NavigationLink(destination: RemoteView(viewModel: viewModel)) {
                        Label("TV Remote", systemImage: "tv")
                    }
                    .tag(0)
                    NavigationLink(destination: MouseView(viewModel: viewModel)) {
                        Label("Mouse Pad", systemImage: "cursorarrow.click.2")
                    }
                    .tag(1)
                    NavigationLink(destination: Text("")) {
                        Label("Apps", systemImage: "apps.ipad.landscape")
                    }
                    .tag(2)
                    NavigationLink(destination: SubscriptionsView(viewModel: viewModel)) {
                        Label("Subscriptions", systemImage: "antenna.radiowaves.left.and.right")
                    }
                    .tag(3)
                    NavigationLink(destination: Text("")) {
                        Label("Send Toasts", systemImage: "text.bubble")
                    }
                    .tag(4)
                    NavigationLink(destination: LogView(viewModel: viewModel)) {
                        Label("Logs", systemImage: "folder.badge.gearshape")
                    }
                    .tag(5)
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
                
                Section(header: Text("NOTES")) {
                    Text("Specify your LG TV URL in ViewModel.swift")
                        .font(.footnote)
                }
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        toggleSidebar()
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                    .help("Toggle Sidebar")
                }
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
            }
            .alert("Please accept registration prompt on the TV.",
                   isPresented: $viewModel.showPromptAlert) {
            }
        }
        .onAppEnteredForeground {
            viewModel.ping()
        }
    }
    
    func toggleSidebar() {
        NSApp
            .keyWindow?
            .firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
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
