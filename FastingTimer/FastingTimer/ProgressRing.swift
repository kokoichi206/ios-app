//
//  ProgressRing.swift
//  FastingTimer
//
//  Created by Takahiro Tominaga on 2022/01/21.
//

import SwiftUI

struct ProgressRing: View {
    @State var progress = 0.0
    var body: some View {
        ZStack {
            // MARK: Placeholder Ring
            
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            // MARK: Colored Ring
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.3689519167, blue: 0.4431474507, alpha: 1)), Color(#colorLiteral(red: 0.68470186, green: 0.02242908254, blue: 0.5804709196, alpha: 1)), Color(#colorLiteral(red: 0.8791713119, green: 0.4633731246, blue: 0.7116953731, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9512596726, blue: 0.8634214401, alpha: 1)), Color(#colorLiteral(red: 0.01154823136, green: 0.441688925, blue: 0.9674546123, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect((Angle(degrees: 270)))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            VStack(spacing: 30) {
                // MARK: Elapsed Time
                
                VStack(spacing: 5) {
                    Text("Elapsed time")
                        .opacity(0.7)
                    
                    Text("0:00")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top)
                
                // MARK: Remaining Time
                
                VStack(spacing: 5) {
                    Text("Remaining time")
                        .opacity(0.7)
                    
                    Text("0:00")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onAppear {
            progress = 1
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
    }
}
