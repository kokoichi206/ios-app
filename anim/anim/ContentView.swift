//
//  ContentView.swift
//  anim
//
//  Created by Takahiro Tominaga on 2022/03/23.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 255 / 255, green: 255 / 255, blue: 235 / 255)
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.offWhite)
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

struct ContentView: View {
    var body: some View {

        ZStack {
            Color.offWhite
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.offWhite)
//                .frame(width: 300, height: 300)
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            Button(action: {
                print("Button tapped")
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.gray)
            }
            .buttonStyle(SimpleButtonStyle())
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
