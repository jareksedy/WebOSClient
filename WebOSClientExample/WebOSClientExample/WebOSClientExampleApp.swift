//
//  WebOSClientExampleApp.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 11.01.2024.
//

import SwiftUI

@main
struct WebOSClientExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .commands {
            SidebarCommands()
        }
    }
}
