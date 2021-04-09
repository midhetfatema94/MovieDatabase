//
//  ContentView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/8/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    enum sortBy: String {
        case popularity = "Popularity"
        case ratings = "Rating"
        case general = "Default"
    }
    
    @ObservedObject var movieList = MovieList()
    @State var pageCount = 1
    @State var showActionSheet = false
    @State var sorting: sortBy = .general
    
    var body: some View {
        NavigationView {
            List {
                Section(footer:
                            HStack {
                                Spacer ()
                                
                                ProgressView()
                                .onAppear(perform: movieList.loadMovies)
                                
                                Spacer()
                            }
                ) {
                    ForEach(movieList.movies) {movie in
                        NavigationLink(
                            destination: MovieDetailView(movie: movie),
                            label: {
                                HStack {
                                    WebImage(url: URL(string: movie.thumbnailUrlString))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 75)
                                    
                                    VStack(alignment: .leading) {
                                        Text(movie.name)
                                            .font(.title3)
                                        Text(movie.releaseDateFormatted)
                                            .font(.caption)
                                    }
                                }
                        })
                    }
                }
            }
            .navigationTitle("Movies: Now Playing")
            .navigationBarItems(trailing: Button(action: {
                self.showActionSheet = true
            }, label: {
                Text("Sort by: \(sorting.rawValue)")
            }))
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Sort Movies by"), message: Text("Select a new color"), buttons: [
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
