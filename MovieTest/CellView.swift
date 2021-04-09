//
//  CellView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CellView: View {
    
    @State var movie: Movie
    
    var body: some View {
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

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(movie: Movie())
    }
}
