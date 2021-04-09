//
//  ContentView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/8/21.
//

import SwiftUI

struct ContentView: View {
    
    enum sortBy: String {
        case popularity = "Popularity"
        case ratings = "Rating"
        case general = "Default"
    }
    
    @State var movies = [Movie]()
    @State var pageCount = 1
    @State var showActionSheet = false
    @State var sorting: sortBy = .general
    
    var body: some View {
        NavigationView {
            List {
                ForEach(movies) {movie in
                    NavigationLink(
                        destination: MovieDetailView(movie: movie),
                        label: {
                            HStack {
                                if let thumbnail = movie.thumbnailImage {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 75)
                                }
                                
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
            .navigationTitle("Movies: Now Playing")
            .navigationBarItems(trailing: Button(action: {
                self.showActionSheet = true
            }, label: {
                Text("Sort by: \(sorting.rawValue)")
            }))
        }
        .onAppear(perform: loadMovies)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Sort Movies by"), message: Text("Select a new color"), buttons: [
                .default(Text("Default")) {
                    self.sorting = .general
                    self.movies = self.movies.sorted()
                },
                .default(Text("Popularity")) {
                    self.sorting = .popularity
                    self.movies = self.movies.sorted(by: { (lhs, rhs) -> Bool in
                        lhs.popularity > rhs.popularity
                    })
                },
                .default(Text("Rating")) {
                    self.sorting = .ratings
                    self.movies = self.movies.sorted(by: { (lhs, rhs) -> Bool in
                        lhs.rating ?? 0 > rhs.rating ?? 0
                    })
                },
                .cancel()
            ])
        }
    }
    
    func loadMovies() {
        let apiKey = "9d1344a380317dd75eafb84e11397393"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(pageCount)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("No data in response: ", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []), let list = json as? [String: Any] {
                print("response", json, list)
                if let myList = try? JSONSerialization.data(withJSONObject: list["results"] ?? [:], options: []) {
                    if let movieData = try? JSONDecoder().decode([Movie].self, from: myList) {
                        self.movies = movieData.sorted()
                        self.pageCount += 1
                        print("successful response")
                    }
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
