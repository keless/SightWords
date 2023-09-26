//  Copyright © 2023 Apple Inc. All rights reserved.

import SwiftUI

struct ContentView: View {
    
    var listOfWords: [String]
    
    //TODO: have a button which can add a new word to the list
    //TODO: drag words from the list onto the canvas as WordCircles
    
    var body: some View {
        HStack {
            VStack {
                WordCircle(wordText: "word4")
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }.frame(maxWidth: .infinity, alignment: .leading)
            List {
                ForEach(listOfWords, id: \.self) { item in
                    WordList(wordText: item).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }.frame(width: 400, alignment: .trailing)
        }
        .padding()
    }
}

struct WordList: View {
    var wordText: String
    var body: some View {
        Text(wordText)
            .font(.largeTitle)
            .padding()
            .frame(width: .infinity, alignment: .center)
    }
}

struct WordCircle: View {
    var wordText: String
    var body: some View {
        
        Text(wordText)
            .font(.largeTitle)
            .padding()
            .overlay(
            Circle()
                .stroke()
            )
            
    }
}

#Preview {
    ContentView(listOfWords: ["word1", "word2", "word3", "word4"])
}
