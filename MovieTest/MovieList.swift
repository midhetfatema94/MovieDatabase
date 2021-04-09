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
    
    // Tracks last page loaded. Used to load next page
    var currentPage = 1
    // Tracks loading status, multiple calls for the same page are restricted
    var isLoading = false
    
    
    private var cancellable: AnyCancellable?
    
    func loadMovies() {
        let apiKey = "9d1344a380317dd75eafb84e11397393"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(currentPage)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        if isLoading { return } else { isLoading = true }
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in

            guard let data = data else {
                print("No data in response: ", error?.localizedDescription ?? "Unknown error")
                return
            }

            if let result = try? JSONDecoder().decode(Result.self, from: data) {
                DispatchQueue.main.async {[weak self] in
                    let newPage = result.results
                    self?.movies += newPage.sorted()
                    self?.currentPage += 1
                    print("successful response")
                    self?.isLoading = false
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

class Result: Codable {
    
    var page: Int = 0
    var results = [Movie]()
    
    enum CodingKeys: CodingKey {
        case page, results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        results = try container.decode([Movie].self, forKey: .results)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(page, forKey: .page)
        try container.encode(results, forKey: .results)
    }
}
