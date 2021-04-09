//
//  MovieModel.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/8/21.
//

import Foundation
import UIKit

class Movie: Codable, Identifiable, Comparable {
    
    var id: Int = 0
    var name: String
    var rating: Double?
    var synopsis: String
    var thumbnailUrlString: String
    var thumbnailImage: UIImage?
    var releaseDateString = ""
    var releaseDate = Date()
    var releaseDateFormatted = ""
    var popularity: Double = 0
    
    enum CodingKeys: CodingKey {
        case id, title, vote_average, overview, poster_path, release_date, popularity
    }
    
    init() {
        name = "Alladin"
        synopsis = ""
        thumbnailUrlString = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .title)
        thumbnailUrlString = try container.decode(String.self, forKey: .poster_path)
        rating = try container.decode(Double.self, forKey: .vote_average)
        synopsis = try container.decode(String.self, forKey: .overview)
        releaseDateString = try container.decode(String.self, forKey: .release_date)
        popularity = try container.decode(Double.self, forKey: .popularity)
        
        if let fileUrl = URL(string: "https://image.tmdb.org/t/p/original\(thumbnailUrlString)"), let imageData = try? Data(contentsOf: fileUrl) {
            thumbnailImage = UIImage(data: imageData)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: releaseDateString) {
            releaseDate = date
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(rating, forKey: .vote_average)
        try container.encode(synopsis, forKey: .overview)
        try container.encode(thumbnailUrlString, forKey: .poster_path)
        try container.encode(releaseDateString, forKey: .release_date)
        try container.encode(popularity, forKey: .popularity)
    }
    
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        lhs.releaseDate < rhs.releaseDate
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
