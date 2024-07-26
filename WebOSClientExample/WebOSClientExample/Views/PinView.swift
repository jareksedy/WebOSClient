//
//  PinView.swift
//  WebOSClientExample
//
//  Created by Yaroslav Sedyshev on 26.07.2024.
//

import SwiftUI

struct PinView: View {
    @Binding var showPin: Bool
    @State var pin: String = ""
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("Enter PIN appearing on your TV screen:")
            TextField("...", text: $pin)
            HStack {
                Button(action: {
                    showPin = false
                }, label: {
                    HStack {
                        Text("Cancel")
                    }
                    .padding(5)
                })
                Button(action: {
                    viewModel.tv?.send(.setPin(pin))
                    showPin = false
                }, label: {
                    HStack {
                        Text("Register")
                    }
                    .padding(5)
                })
                .buttonStyle(.borderedProminent)
                .disabled(!isValidPIN(pin: pin))
            }
            .padding(.top, 5)
        }
        .background(.clear)
        .padding()
    }
    
    private func isValidPIN(pin: String) -> Bool {
        let validLengths: Set<Int> = [8]
        let isNumeric = pin.allSatisfy { $0.isNumber }
        let hasValidLength = validLengths.contains(pin.count)
        return isNumeric && hasValidLength
    }
}
