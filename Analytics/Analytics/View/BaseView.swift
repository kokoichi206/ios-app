//
//  BaseView.swift
//  Analytics
//
//  Created by Takahiro Tominaga on 2022/01/21.
//

import SwiftUI

struct BaseView: View {
    
    // Using Image Names as Tab...
    @State var currentTab = "home"
    
    // Hiding Native One..
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Tab View..
            TabView(selection: $currentTab) {
                
                Text("Home")
                    .tag("house")
                
                Text("Graph")
                    .tag("chart.xyaxis.line")
                
                Text("Chat")
                    .tag("equal.square.fill")
                
                Text("Settings")
                    .tag("gearshape.fill")
            }
            
            // Custom Tab Bar...
            HStack(spacing: 40) {
                
                // Tab Buttons...
                TabButton(image: "house")
                TabButton(image: "chart.xyaxis.line")
                
                // Center Add Button...
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                TabButton(image: "equal.square.fill")
                TabButton(image: "gearshape.fill")
            }
//            .foregroundColor(Color.black)
        }
    }
    
    @ViewBuilder
    func TabButton(image: String) -> some View {
        
        Button {
            withAnimation {
                currentTab = image
            }
        } label: {
//            Image(systemName: "person.crop.circle.badge.plus")
            Image(systemName: image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(
                
                    currentTab == image ? Color.black : Color.gray.opacity(0.8)
                )
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
