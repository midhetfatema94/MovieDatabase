//
//  ContentView.swift
//  MovieTest
//
//  Created by Midhet Sulemani on 4/8/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var movies = [Movie]()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
