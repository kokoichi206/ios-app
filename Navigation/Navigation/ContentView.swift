//
//  ContentView.swift
//  Navigation
//
//  Created by Takahiro Tominaga on 2022/03/24.
//

import SwiftUI

struct ResultView: View {
    var choice: String
    
    var body: some View {
        Text("You chose \(choice)")
    }
}

struct FlipCoinView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("You're going to flip a coin")
                
                NavigationLink(destination: ResultView(choice: "Heads")) {
                    Text("Heads")
                }
                NavigationLink(destination: ResultView(choice: "Tails")) {
                    Text("Tails")
                }
            }
            .navigationBarTitle("Navigation", displayMode: .inline)
        }
    }
}

struct DetailView: View {
    
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: Text("Second View"), isActive: $isShowingDetailView) { EmptyView() }

                Button("Tap to show detail") {
                    // More code here
                    // heavy tasks..., network request, etc
                    self.isShowingDetailView = true
                }
            }
            .navigationBarTitle("Navigation", displayMode: .inline)
        }
    }
}

struct TagSelectionView: View {
    
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: Text("Second View"), tag: "Second", selection: $selection) { EmptyView() }
                NavigationLink(destination: Text("Third View"), tag: "Third", selection: $selection) { EmptyView() }

                Button("Tap to show second") {
                    self.selection = "Second"
                }
                Button("Tap to show third") {
                    self.selection = "Third"
                }
            }
            .navigationBarTitle("Navigation", displayMode: .inline)
        }
    }
}

struct HideView: View {
    
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: Text("Second View"), isActive: $isShowingDetailView) { EmptyView() }

                Button("Tap to show detail") {
                    self.isShowingDetailView = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isShowingDetailView = false
                    }
                }
            }
            .navigationBarTitle("Navigation", displayMode: .inline)
        }
    }
}


class User: ObservableObject {
    @Published var score = 0
}

struct ChangeView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        VStack {
            Text("Score: \(user.score)")
            Button("Increase") {
                self.user.score += 1
            }
        }
    }
}
struct ShareItemView: View {
    
    @ObservedObject var user = User()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Score: \(user.score)")
                
                NavigationLink(destination: ChangeView()) {
                    Text("Show Detail View")
                }
            }
            .navigationBarTitle("Navigation")
        }
        .environmentObject(user)
    }
}


struct BarButtonsView: View {
    
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            Text("Score: \(score)")
                .navigationBarTitle("Navigation")
                .navigationBarItems(
                    trailing:
                        HStack {
                            Button("Subtract 1") {
                                self.score -= 1
                            }
                            
                            Button("Add 1") {
                                self.score += 1
                            }
                        }
                        
                )
        }
    }
}


struct ToggleFullScreenView: View {
    
    @State private var fullScreen = false
    
    var body: some View {
        NavigationView {
            Button("Toggle Full Screen") {
                self.fullScreen.toggle()
            }
            .navigationBarTitle("Full Screen")
            .navigationBarHidden(fullScreen)
        }
        .statusBar(hidden: fullScreen)
    }
}

struct ContentView: View {
    
    @State private var fullScreen = false
    
    var body: some View {
        NavigationView {
            Button("Toggle Full Screen") {
                self.fullScreen.toggle()
            }
            .navigationBarTitle("Full Screen")
            .navigationBarHidden(fullScreen)
        }
        .statusBar(hidden: fullScreen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
