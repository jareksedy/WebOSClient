//
//  MouseView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 13.01.2024.
//

import SwiftUI

fileprivate enum Constants {
    static let width: CGFloat = 640
    static let height: CGFloat = 360
    static let divider: CGFloat = 18
}

struct MouseView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var mouseLocation: NSPoint = NSPoint(x: Constants.width / 2, y: Constants.height / 2) {
        didSet {
            dx = (mouseLocation.x - Constants.width / 2) / Constants.divider
            dy = (mouseLocation.y - Constants.height / 2) / Constants.divider
            
            viewModel.tv?.sendKey(.move(dx: Int(dx), dy: Int(dy)))
            
            if dy > 13 {
                viewModel.tv?.sendKey(.scroll(dx: 0, dy: -10))
            }
            
            if dy < -13 {
                viewModel.tv?.sendKey(.scroll(dx: 0, dy: 10))
            }
        }
    }
    @State private var isDragged: Bool = false
    @State private var isTapped: Bool = false
    @State private var dx: CGFloat = 0
    @State private var dy: CGFloat = 0
    
    var body: some View {
        ZStack {
            Text("DRAG AROUND AND TAP")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .font(.system(size: 10))
                .monospaced()
                .opacity(0.25)
                .padding(.bottom, 250)
            
            Image(systemName: "plus")
                .foregroundColor(.accentColor)
                .fontWeight(.ultraLight)
                .font(.system(size: 72))
                .monospaced()
                .opacity(0.25)
            
            Text("DX: \(dx.formatted()) DY: \(dy.formatted())")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .font(.system(size: 10))
                .monospaced()
                .opacity(0.25)
                .padding(.top, 250)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: Constants.width, height: Constants.height)
                .contentShape(Rectangle())
            
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: 25, height: 25)
                .scaleEffect(isDragged ? 3.0 : 1.0)
                .opacity(isDragged ? 0.25 : 0.75)
                .position(x: mouseLocation.x, y: mouseLocation.y)
                .overlay(
                    Circle()
                        .foregroundColor(.accentColor)
                        .scaleEffect(isTapped ? 0.175 : 0)
                        .opacity(isTapped ? 0.25 : 1)
                        .position(x: mouseLocation.x, y: mouseLocation.y)
                )
            
        }
        .frame(width: Constants.width, height: Constants.height)
        .simultaneousGesture(
            DragGesture(coordinateSpace: .named("MouseView"))
                .onChanged { value in
                    mouseLocation = value.location
                    withAnimation(.bouncy(duration: 0.15, extraBounce: 0.3)) {
                        isDragged = true
                    }
                }
                .onEnded { value in
                    mouseLocation = value.location
                    withAnimation(.bouncy(duration: 0.15, extraBounce: 0.3)) {
                        isDragged = false
                    }
                }
        )
        .onTapGesture() { value in
            mouseLocation = value
            viewModel.tv?.sendKey(.click)
            withAnimation(.bouncy(duration: 0.25)) {
                isDragged = true
                isTapped = true
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                withAnimation(.bouncy(duration: 0.25)) {
                    isDragged = false
                    isTapped = false
                }
            }
        }
        .coordinateSpace(name: "MouseView")
        .navigationTitle("WebOSClientExample :: Mouse Pointer")
    }
}

extension CGFloat {
    func formatted() -> String {
        return String(format: "%.2f", self)
    }
}
