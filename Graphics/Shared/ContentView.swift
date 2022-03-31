//
//  ContentView.swift
//  Shared
//
//  Created by Takahiro Tominaga on 2022/03/31.
//

import SwiftUI

struct ContentView: View {
    
    enum GameState {
        case expanding, stopped, reset
    }
    
    enum GameResult {
        case success, failure
    }
    
    @State var gameState = GameState.reset
    @State var gameResult = GameResult.success
    
    @State var originDate = 0.0
    @State var stoppedDate = 0.0
    
    @State var speed = 1.0
    
    let targetSpan = 30

    var body: some View {
        
        TimelineView(.animation) { timeline in
            
            Canvas { context, size in
                
                let now = (gameState == .reset ? 0 : gameState == .stopped ? (stoppedDate - originDate) : timeline.date.timeIntervalSinceReferenceDate - originDate) * speed
                let angle = Angle(degrees: now * 60)
                let x = min(1.5, angle.radians)
                
                let targetRadius = size.width * 0.7
                
                context.stroke(Circle().path(in: CGRect(origin: CGPoint(x: 0.5 * (size.width - targetRadius), y: 0.5 * (size.height - targetRadius)), size: CGSize(width: targetRadius, height: targetRadius))), with: .color(.purple), lineWidth: CGFloat(targetSpan))
                
                var transparentContext = context
                transparentContext.opacity = 0.8
                
                let radius = size.width * x
                
                transparentContext.fill(
                    Circle()
                        .path(in: CGRect(origin:
                                            CGPoint(x: 0.5 * (size.width - radius),
                                                    y: 0.5 * (size.height - radius)), size:
                                            CGSize(width: radius, height: radius))), with: .color(.orange)
                )
                
                if x >= 1.5 {
                    asyncDetached {
                        // Global actor
                        stoppedDate = Date.now.timeIntervalSinceReferenceDate
                        gameState = .stopped
                    }
                }
                
                if radius > targetRadius + targetSpan || radius < targetRadius - targetSpan {
                    asyncDetached {
                        gameResult = .failure
                    }
                } else {
                    asyncDetached {
                        gameResult = .success
                    }
                }
            }
        }
        .onTapGesture {
            if gameState == .reset {
                originDate  = Date.now.timeIntervalSinceReferenceDate
                gameState = .expanding
            }
            else if gameState == .expanding {
                stoppedDate = Date.now.timeIntervalSinceReferenceDate
                gameState = .stopped
            }
            else if gameState == .stopped {
                originDate  = Date.now.timeIntervalSinceReferenceDate
                gameState = .expanding
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
