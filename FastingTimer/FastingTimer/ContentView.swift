//
//  ContentView.swift
//  FastingTimer
//
//  Created by Takahiro Tominaga on 2022/01/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // MARK: Background
            
            Color(#colorLiteral(red: 0.03641154245, green: 0.005049427971, blue: 0.06040825695, alpha: 1))
                .ignoresSafeArea()
            
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 40) {
                // MARK: Title
                
                Text("Let's get started!")
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0.3689519167, blue: 0.4431474507, alpha: 1)))
                
                // MARK: Fasting Plan
                
                Text("16:8")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
             
                Spacer()
            }
            .padding()
                
            VStack(spacing: 40) {
                // MARK: Progress Ring
                
                ProgressRing()
                
                HStack(spacing: 60) {
                    // MARK: Start Time
                    
                    VStack(spacing: 5) {
                        Text("Start")
                            .opacity(0.7)
                        
                        Text(Date(), format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                    
                    // MARK: End Time
                    
                    VStack(spacing: 5) {
                        Text("End")
                            .opacity(0.7)
                        
                        Text(Date().addingTimeInterval(16), format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                }
                
                // MARK: Button
                
                Button {
                    
                } label: {
                    Text("Start fasting")
                        .font(.title3)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
