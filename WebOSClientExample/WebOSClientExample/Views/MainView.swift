//
//  MainView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 11.01.2024.
//

import SwiftUI

struct MainView: View {
    @State var selection: Int = 1
    @State var appFilter: Int = 2
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
                Section(header: Text("CONNECTION STATUS")) {
                    if viewModel.isConnected {
                        Label("Connected", systemImage: "tv")
                            .foregroundColor(.green)
                    } else {
                        Label("Disconnected", systemImage: "tv.slash")
                            .foregroundColor(.red)
                    }
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
                    NavigationLink(destination: AppsView(viewModel: viewModel)) {
                        Label("Apps", systemImage: "apps.ipad.landscape")
                    }
                    .tag(3)
                    NavigationLink(destination: SubscriptionsView(viewModel: viewModel)) {
                        Label("Subscriptions", systemImage: "antenna.radiowaves.left.and.right")
                    }
                    .tag(4)
                    NavigationLink(destination: ToastView(viewModel: viewModel)) {
                        Label("Toasts", systemImage: "text.bubble")
                    }
                    .tag(5)
                    NavigationLink(destination: MiscView(viewModel: viewModel)) {
                        Label("Miscellaneous", systemImage: "wrench.and.screwdriver")
                    }
                    .tag(6)
                    NavigationLink(destination: LogView(viewModel: viewModel)) {
                        Label("Logs", systemImage: "folder.badge.gearshape")
                    }
                    .tag(7)
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
                if selection == 3 {
                    ToolbarItem(placement: .accessoryBar(id: 0)) {
                        Picker("Apps: ", selection: $appFilter) {
                            Text("All").tag(0)
                            Text("System").tag(1)
                            Text("Third-party").tag(2)
                        }
                        .disabled(!viewModel.isConnected)
                        .pickerStyle(.segmented)
                        .onChange(of: appFilter) { _ in
                            switch appFilter {
                            case 0:
                                viewModel.showAllApps()
                            case 1:
                                viewModel.showSystemApps()
                            case 2:
                                viewModel.showNonSystemApps()
                            default:
                                viewModel.showNonSystemApps()
                            }
                        }
                    }
                }
                if selection == 7 {
                    ToolbarItem(placement: .accessoryBar(id: 0)) {
                        Button(action: {
                            viewModel.log = ""
                        }, label: {
                            Image(systemName: "folder.badge.minus")
                            Text("Clear Logs")
                        })
                        .help("Clear Logs")
                    }
                    ToolbarItem(placement: .accessoryBar(id: 0)) {
                        Button(action: {
                            viewModel.tv?.send(.systemInfo)
                        }, label: {
                            Image(systemName: "info.square")
                            Text("System Info")
                        })
                        .help("System Info")
                    }
                }
            }
            .alert("Please accept registration prompt on the TV.",
                   isPresented: $viewModel.showPromptAlert) {
            }
        }
    }
}
