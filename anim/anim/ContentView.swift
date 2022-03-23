//
//  ContentView.swift
//  anim
//
//  Created by Takahiro Tominaga on 2022/03/23.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 255 / 255, green: 255 / 255, blue: 235 / 255)

    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    
    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        // 3 Circles
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
//                    .fill(Color.darkEnd)
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
//                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
//                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
//                    .fill(Color.darkEnd)
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
        
//        ZStack {
//            if isHighlighted {
//                shape
////                    .fill(Color.darkEnd)
//                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
//                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
//                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
//            } else {
//                shape
////                    .fill(Color.darkEnd)
//                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
//                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
//                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
//            }
//        }
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ColorfulToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            ColorfulBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ContentView: View {
    
    @State private var isToggled = false
    
    var body: some View {

        ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd)
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.offWhite)
//                .frame(width: 300, height: 300)
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            
            VStack(spacing: 40) {
                Button(action: {
                    print("Button tapped")
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(ColorfulButtonStyle())
                
                Toggle(isOn: $isToggled) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                }
                // Custom toggle style
                .toggleStyle(ColorfulToggleStyle())
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// #colorLiteral(red: 0.76, green: 0.816, blue: 0.925, alpha: 1)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
