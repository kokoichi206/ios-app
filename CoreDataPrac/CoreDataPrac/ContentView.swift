//
//  ContentView.swift
//  CoreDataPrac
//
//  Created by Takahiro Tominaga on 2022/03/30.
//

import SwiftUI

struct ContentView: View {
    
    let coreDM: CoreDataManager
    @State private var movieTitle: String = ""
    // NOt a good idea to use state to populate data
    // from third party call
    @State private var movies: [Movie] = [Movie]()
    
    private func populateMovies() {
        movies = coreDM.getAllMovies()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title", text: $movieTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save") {
                    // Do not call from a view!!!
                    coreDM.saveMovie(title: movieTitle)
                    populateMovies()
                }
            
                List{
                    
                    ForEach(movies, id: \.self) {movie in
                        Text(movie.title ?? "")
                    }.onDelete { indexSet in
                        indexSet.forEach { index in
                            let movie = movies[index]
                            // delete it using Core Data Manager
                            coreDM.deleteMovie(movie: movie)
                            populateMovies()
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Movie")
            .onAppear {
                populateMovies()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: CoreDataManager())
    }
}
