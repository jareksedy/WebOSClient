//
//  AboutView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 14.01.2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Image(systemName: "tv")
                .foregroundColor(.gray)
                .font(.system(size: 48))
            
            Text("WebOSClientExample App")
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.top, 25)
            
            Text("Copyright © Yaroslav Sedyshev. MIT license.")
                .multilineTextAlignment(.center)
            
            Text("This is an example project intended for demonstration purpose.\nThis app comes with the WebOSCLient Swift library.\nhttps://github.com/jareksedy/WebOSClient.git")
                .multilineTextAlignment(.center)
                .padding(.top, 25)
            
            Text("Important note: In order for this app to operate properly\nyou have to manually specify your LG TV URL in ViewModel.swift.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 5)
        }
        .padding()
        .navigationTitle("WebOSClientExample App :: About")
    }
}
