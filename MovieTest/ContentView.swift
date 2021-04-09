//
//  ContentView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/8/21.
//

import SwiftUI

struct ContentView: View {
    
    enum sortBy: String {
        //Sorting through the "popularity" tag
        case popularity = "Popularity"
        //Sorting through the "vote_average" tag
        case ratings = "Rating"
        //Sorting through the "release_date" tag
        case general = "Default"
    }
    
    @ObservedObject var movieList = MovieList()
    @State var showActionSheet = false
    @State var sorting: sortBy = .general
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: LoaderView(movieList: movieList)) {
                    ForEach(movieList.movies) {movie in
                        CellView(movie: movie)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Movies: Now Playing")
            .navigationBarItems(trailing: Button(action: {
                self.showActionSheet = true
            }, label: {
                HStack(spacing: 1) {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("\(sorting.rawValue)")
                }
            }))
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Sort Movies by"), message: nil, buttons: [
                .default(Text("Default")) {
                    self.sorting = .general
                    self.movieList.movies = self.movieList.movies.sorted()
                },
                .default(Text("Popularity")) {
                    self.sorting = .popularity
                    self.movieList.movies = self.movieList.movies.sorted(by: { (lhs, rhs) -> Bool in
                        lhs.popularity > rhs.popularity
                    })
                },
                .default(Text("Rating")) {
                    self.sorting = .ratings
                    self.movieList.movies = self.movieList.movies.sorted(by: { (lhs, rhs) -> Bool in
                        lhs.rating ?? 0 > rhs.rating ?? 0
                    })
                },
                .cancel()
            ])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
