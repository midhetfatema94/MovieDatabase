//
//  MovieDetailView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/9/21.
//

import SwiftUI

struct MovieDetailView: View {
    
    @State var movie: Movie
    
    var body: some View {
        VStack {
            if let thumbnail = movie.thumbnailImage {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
            }
            
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
                    Text("\(rating) stars")
                        .font(.caption)
                }
                .padding()
            }
            
            Text(movie.synopsis)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie())
    }
}
