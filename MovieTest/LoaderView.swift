//
//  LoaderView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/9/21.
//

import SwiftUI

struct LoaderView: View {
    
    @ObservedObject var movieList: MovieList
    
    var body: some View {
        HStack {
            Spacer()
            
            //Calling the next page on appearance of the footer cell
            ProgressView()
                .onAppear(perform: movieList.loadMovies)
            
            Spacer()
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(movieList: MovieList())
    }
}
