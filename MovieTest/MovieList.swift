//
//  MovieList.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/9/21.
//

import Foundation
import Combine

class MovieList: ObservableObject {
    
    @Published var movies = [Movie]()
    
    // Tells if all records have been loaded. (Used to hide/show activity spinner)
    var movieListFull = false
    // Tracks last page loaded. Used to load next page (current + 1)
    var currentPage = 1
    var isLoading = false
    
    
    private var cancellable: AnyCancellable?
    
    func loadMovies() {
        let apiKey = "9d1344a380317dd75eafb84e11397393"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(currentPage)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        if isLoading { return } else { isLoading = true }
        
        print("loading called")
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in

            guard let data = data else {
                print("No data in response: ", error?.localizedDescription ?? "Unknown error")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []), let list = json as? [String: Any] {
                if let myList = try? JSONSerialization.data(withJSONObject: list["results"] ?? [:], options: []) {
                    if let movieData = try? JSONDecoder().decode([Movie].self, from: myList) {
                        DispatchQueue.main.async {[weak self] in
                            self?.movies += movieData.sorted()
                            self?.currentPage += 1
                            print("successful response")
                            self?.isLoading = false
                        }
                    }
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}
