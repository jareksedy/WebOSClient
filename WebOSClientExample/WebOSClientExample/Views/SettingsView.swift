//
//  SettingsView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 17.01.2024.
//

import SwiftUI

fileprivate enum Constants {
    static let tvIPKey = "tvIPKey"
}

struct SettingsView: View {
    @Binding var showSettings: Bool
    @State var tvIP: String = ""
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("Enter your LG TV IP address:")
            TextField("192.168......", text: $tvIP)
            HStack {
                Button(action: {
                    showSettings = false
                }, label: {
                    HStack {
                        Text("Cancel")
                    }
                    .padding(5)
                })
                Button(action: {
                    viewModel.tv?.disconnect()
                    UserDefaults.standard.setValue(tvIP, forKey: Constants.tvIPKey)
                    showSettings = false
                }, label: {
                    HStack {
                        Text("Save and Connect")
                    }
                    .padding(5)
                })
                .buttonStyle(.borderedProminent)
                .disabled(!isValidIP(ip: tvIP))
            }
            .padding(.top, 5)
        }
        .background(.clear)
        .padding()
    }
    
    private func isValidIP(ip: String) -> Bool {
        let ipAddressRegex = #"^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){2}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$"#
        
        return NSPredicate(format: "SELF MATCHES %@", ipAddressRegex).evaluate(with: ip)
    }
}
