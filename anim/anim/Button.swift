//
//  Button.swift
//  anim
//
//  Created by Takahiro Tominaga on 2022/03/23.
//

import SwiftUI

struct Button: View {
    var body: some View {
        VStack {
            Text("Button")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(width: 200, height: 60)
                .background(
                    ZStack {
                        // Color layer
                        Color(#colorLiteral(red: 0.76, green: 0.816, blue: 0.925, alpha: 1))
                        
                        // inner shadow
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .foregroundColor(.white)
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.76, green: 0.816, blue: 0.925, alpha: 0.7)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(2)
                            .blur(radius: 2)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.76, green: 0.816, blue: 0.925, alpha: 1)), radius: 20, x: 20, y: 20)
                .shadow(color: Color(#colorLiteral(red: 0.99, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.89, green: 0.886, blue: 0.955, alpha: 0.7)))
        .ignoresSafeArea(.all)
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        Button()
    }
}
