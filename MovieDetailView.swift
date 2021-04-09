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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie())
    }
}
