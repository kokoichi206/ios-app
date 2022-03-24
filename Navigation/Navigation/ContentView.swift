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


extension Color {
    static let primaryOrange = Color(red: 240 / 255, green: 156 / 255, blue: 106 / 255)

    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    
    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
}



struct MyListView: View {
    var body: some View {
        Text("MyListView")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct UploadView: View {
    var body: some View {
        Text("Upload View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}


struct ContentView: View {

    let iconSize : CGFloat = 40
    
    @State var selectedTab = "square.grid.2x2.fill"
    
    var body: some View {
//        NavigationView {
//            HStack(spacing: 30) {
//                NavigationLink {
//                    MyListView()
//                } label: {
//                    Image(systemName: "square.grid.2x2.fill")
//                        .font(.largeTitle)
//                }
//
//            }
//        }
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                MyListView()
                    .tag("square.grid.2x2.fill")
                UploadView()
                    .tag("upload")
                SettingsView()
                    .tag("gearshape.fill")
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all, edges: .bottom)
            
            HStack(spacing: 0) {
                
                ForEach(tabs, id: \.self){image in
                    TabButton(image: image, selectedTab: $selectedTab)
                    
                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            
            // MAYBE TODO: ignoring tabview elevation....
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// Image Names...
var tabs = ["square.grid.2x2.fill", "upload", "gearshape.fill"]

// arrow.up.to.line.compact
//shift.fill
//minus
//arrow.up.to.line.compact

struct TabButton: View {
    
    let iconSize : CGFloat = 40
    let uploadBarHeight : CGFloat = 10

    var image : String
    @Binding var selectedTab : String
    
    var body: some View {
        
        Button(action: {selectedTab = image}) {
            if (image == "upload") {
                VStack(spacing: 0) {
                    Image(systemName: "rectangle.fill")
                        .resizable()
                        .frame(width: iconSize - uploadBarHeight, height: uploadBarHeight)
                    Image(systemName: "shift.fill")
                        .resizable()
                        .frame(width: iconSize - uploadBarHeight, height: iconSize - uploadBarHeight)
                }
                .foregroundColor(selectedTab == image ? Color.primaryOrange : Color.black.opacity(0.4))
            } else {
                Image(systemName: image)
                    .renderingMode(.template)
                    .font(.system(size: iconSize))
                    .foregroundColor(selectedTab == image ? Color.primaryOrange : Color.black.opacity(0.4))
                    .padding()
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
