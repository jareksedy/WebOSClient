//
//  RemoteView.swift
//  WebOSClientExample
//
//  Created by Ярослав on 13.01.2024.
//

import SwiftUI

fileprivate enum Constants {
    static let size: CGFloat = 25
}

struct RemoteView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.volumeUp)
                    }) {
                        Image(systemName: "speaker.plus")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.volumeDown)
                    }) {
                        Image(systemName: "speaker.minus")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                }
                
                HStack {
                    VStack {
                        Button(action: {
                            viewModel.tv?.sendKey(.left)
                        }) {
                            Image(systemName: "arrowtriangle.left")
                                .frame(width: Constants.size, height: Constants.size)
                        }
                    }
                    
                    VStack {
                        Button(action: {
                            viewModel.tv?.sendKey(.up)
                        }) {
                            Image(systemName: "arrowtriangle.up")
                                .frame(width: Constants.size, height: Constants.size)
                        }
                        
                        Button(action: {
                            viewModel.tv?.sendKey(.enter)
                        }) {
                            Image(systemName: "circle")
                                .frame(width: Constants.size, height: Constants.size)
                        }
                        
                        Button(action: {
                            viewModel.tv?.sendKey(.down)
                        }) {
                            Image(systemName: "arrowtriangle.down")
                                .frame(width: Constants.size, height: Constants.size)
                        }
                    }
                    
                    VStack {
                        Button(action: {
                            viewModel.tv?.sendKey(.right)
                        }) {
                            Image(systemName: "arrowtriangle.right")
                                .frame(width: Constants.size, height: Constants.size)
                        }
                    }
                }
                .padding()
                
                VStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.channelUp)
                    }) {
                        Image(systemName: "plus.rectangle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.channelDown)
                    }) {
                        Image(systemName: "minus.rectangle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                }
            }
            
            Spacer()
                .frame(height: 25)
            
            HStack {
                Button(action: {
                    viewModel.tv?.sendKey(.back)
                }) {
                    Image(systemName: "arrowshape.turn.up.backward")
                        .frame(width: Constants.size, height: Constants.size)
                }
                Button(action: {
                    viewModel.tv?.sendKey(.home)
                }) {
                    Image(systemName: "house")
                        .frame(width: Constants.size, height: Constants.size)
                }
                Button(action: {
                    viewModel.tv?.sendKey(.menu)
                }) {
                    Image(systemName: "gearshape")
                        .frame(width: Constants.size, height: Constants.size)
                }
            }
            
            Spacer()
                .frame(height: 25)
            
            HStack {
                Button(action: {
                    viewModel.tv?.sendKey(.rewind)
                }) {
                    Image(systemName: "backward")
                        .frame(width: Constants.size, height: Constants.size)
                }
                Button(action: {
                    viewModel.tv?.sendKey(.play)
                }) {
                    Image(systemName: "play")
                        .frame(width: Constants.size, height: Constants.size)
                }
                Button(action: {
                    viewModel.tv?.sendKey(.pause)
                }) {
                    Image(systemName: "pause")
                        .frame(width: Constants.size, height: Constants.size)
                }
                Button(action: {
                    viewModel.tv?.sendKey(.stop)
                }) {
                    Image(systemName: "stop")
                        .frame(width: Constants.size, height: Constants.size)
                }
            }
            
            Spacer()
                .frame(height: 25)
            
            HStack {
                Button(action: {
                    viewModel.tv?.sendKey(.red)
                }) {
                    Text("·")
                        .frame(maxWidth: Constants.size * 2, maxHeight: 25)
                }
                .buttonStyle(ColoredButtonStyle(color: .red))
                Button(action: {
                    viewModel.tv?.sendKey(.green)
                }) {
                    Text("··")
                        .frame(maxWidth: Constants.size * 2, maxHeight: 25)
                }
                .buttonStyle(ColoredButtonStyle(color: .green))
                Button(action: {
                    viewModel.tv?.sendKey(.yellow)
                }) {
                    Text("···")
                        .frame(maxWidth: Constants.size * 2, maxHeight: 25)
                }
                .buttonStyle(ColoredButtonStyle(color: .yellow))
                Button(action: {
                    viewModel.tv?.sendKey(.blue)
                }) {
                    Text("····")
                        .frame(maxWidth: Constants.size * 2, maxHeight: 25)
                }
                .buttonStyle(ColoredButtonStyle(color: .blue))
            }
            
            Spacer()
                .frame(height: 25)
        }
        .padding()
        .navigationTitle("WebOSClientExample App :: TV Remote")
    }
}


struct ColoredButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? .gray : color)
            .cornerRadius(6.0)
            .padding()
    }
}
