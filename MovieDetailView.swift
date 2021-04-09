//
//  MovieDetailView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    
    @State var movie: Movie
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: movie.thumbnailUrlString))
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            
            VStack {
                Text(movie.name)
                    .font(.title)
                Text(movie.releaseDateFormatted)
                    .font(.title3)
            }
            .padding()
            
            if let rating = movie.rating {
                VStack {
                    //Add stars below
                    HStack {
                        ForEach(1 ..< 6) {star in
                            if star <= Int(rating) {
                                Image(systemName: "star.fill")
                            } else if Double(star - 1) < rating {
                                Image(systemName: "star.leadinghalf.fill")
                            } else {
                                Image(systemName: "star")
                            }
                        }
                    }
                    Text(getRating(value: rating))
                        .font(.caption)
                }
                .padding()
            }
            
            Text(movie.synopsis)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    func getRating(value: Double) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: value)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        
        if value == 1 {
            return String("\(formatter.string(from: number) ?? "") star")
        } else {
            return String("\(formatter.string(from: number) ?? "") stars")
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie())
    }
}
