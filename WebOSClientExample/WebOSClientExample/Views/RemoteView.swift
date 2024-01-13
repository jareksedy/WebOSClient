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
    @State var isMuted: Bool = false
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.num1)
                    }) {
                        Image(systemName: "1.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num2)
                    }) {
                        Image(systemName: "2.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num3)
                    }) {
                        Image(systemName: "3.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                }
                HStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.num4)
                    }) {
                        Image(systemName: "4.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num5)
                    }) {
                        Image(systemName: "5.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num6)
                    }) {
                        Image(systemName: "6.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                }
                HStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.num7)
                    }) {
                        Image(systemName: "7.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num8)
                    }) {
                        Image(systemName: "8.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num9)
                    }) {
                        Image(systemName: "9.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                }
                HStack {
                    Button(action: {
                        viewModel.tv?.sendKey(.info)
                    }) {
                        Image(systemName: "info")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.num0)
                    }) {
                        Image(systemName: "0.circle")
                            .frame(width: Constants.size, height: Constants.size)
                    }
                    Button(action: {
                        viewModel.tv?.sendKey(.exit)
                    }) {
                        Image(systemName: "xmark.square")
                            .frame(width: Constants.size, height: Constants.size)
                            .foregroundColor(.red)
                    }
                }
            }

            Spacer()
                .frame(height: 25)
            
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
                Button(action: {
                    viewModel.tv?.sendKey(.mute)
                    isMuted.toggle()
                }) {
                    Image(systemName: isMuted ? "speaker" : "speaker.slash")
                        .frame(width: Constants.size, height: Constants.size)
                }
            }
            
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
                        .frame(width: Constants.size * 3, height: Constants.size)
                }
                .buttonStyle(ColoredButtonStyle(color: .red))
                Button(action: {
                    viewModel.tv?.sendKey(.green)
                }) {
                    Text("··")
                        .frame(width: Constants.size * 3, height: Constants.size)
                }
                .buttonStyle(ColoredButtonStyle(color: .green))
                Button(action: {
                    viewModel.tv?.sendKey(.yellow)
                }) {
                    Text("···")
                        .frame(width: Constants.size * 3, height: Constants.size)
                }
                .buttonStyle(ColoredButtonStyle(color: .yellow))
                Button(action: {
                    viewModel.tv?.sendKey(.blue)
                }) {
                    Text("····")
                        .frame(width: Constants.size * 3, height: Constants.size)
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
            .foregroundColor(.white)
            .background(configuration.isPressed ? .gray : color)
            .cornerRadius(6.0)
            .padding()
    }
}
