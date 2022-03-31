//
//  ContentView.swift
//  Shared
//
//  Created by Takahiro Tominaga on 2022/03/31.
//

import SwiftUI

struct ContentView: View {

    @State var originDate = 0.0

    var body: some View {        
        
        TimelineView(.animation) { timeline in
            
            Canvas { context, size in
                
                let now = timeline.date.timeIntervalSinceReferenceDate - originDate
                let angle = Angle(degrees: now * 60)
                let x = angle.radians
                
                let radius = size.width * x
                
                context.fill(
                    Circle()
                        .path(in: CGRect(origin:
                                            CGPoint(x: 0.5 * (size.width - radius),
                                                    y: 0.5 * (size.height - radius)), size:
                                            CGSize(width: radius, height: radius))), with: .color(.orange)
                )
            }
        }
        .task {
            originDate = Date.now.timeIntervalSinceReferenceDate
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
