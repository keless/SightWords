//  Copyright © 2023 Apple Inc. All rights reserved.

import SwiftUI

import AVFoundation

struct ContentView: View {
    
    let synthesizer: AVSpeechSynthesizer
        
    @State var wordsOnCanvas: [String]
        
    var body: some View {
        HStack {
            VStack {
                HexGrid(synthesizer: synthesizer, words: wordsOnCanvas)
                    .frame(maxWidth: .infinity, alignment: .leading)
    
                HStack {
                    Button(action: {
                        doAddWord()
                    }, label: {
                        Text("Add Word")
                    }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).buttonStyle(.bordered)
                    Button(action: {
                        doClearWords()
                    }, label: {
                        Text("Clear Words")
                    }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).buttonStyle(.bordered)
                }.frame(maxWidth: .infinity)
            }

        }
        .padding()
    }
    
    func doAddWord() {
        
        alertTextField(title: "Add Word", message: "Add a sight word to the list.", hintText: "word", primaryButtonTitle: "Add", secondaryButtonTitle: "Cancel", primaryAction: { wordStr in
            
            //TODO: if word already exists in wordsOnCanvas, dont add it again?
            
            wordsOnCanvas.append(wordStr)
        }, secondaryAction: {
            // meh
        })
    }
    
    func doClearWords() {
        wordsOnCanvas = []
    }
    
    func alertTextField(title: String, message: String, hintText: String, primaryButtonTitle: String, secondaryButtonTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        // cancel button
        alert.addAction(.init(title: secondaryButtonTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        // primary button
        alert.addAction(.init(title: primaryButtonTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        
        rootViewController().present(alert, animated: true, completion: nil)
    }
    
    func rootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct WordList: View {
    var wordText: String
    var body: some View {
        Text(wordText)
            .font(.largeTitle)
            .padding()
    }
}

struct WordCircle: View, Hashable {
    var id: String {
        wordText
    }
    
    // Show a circle with a word in it
    
    // implements OffsetCoordinateProviding so it can belong to a HexGrid

    var wordText: String
    var body: some View {
        
        VStack{
            Button(action: {
                sayWord()
            }){
               Text(wordText)
                    .font(.largeTitle)
                    .frame(width: 200, height: 200)
                    .foregroundColor(Color.black)
                    .background(Color.gray)
                    .clipShape(Circle())
            }.buttonStyle(PlainButtonStyle())
        }.frame(width: 225, height: 225)
    }
    
    let synthesizer: AVSpeechSynthesizer
    
    func sayWord() {

        let utterance = AVSpeechUtterance(string: wordText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-EN")
        //utterance.rate = 0.1
        
        synthesizer.speak(utterance)
    }
    

}


struct HexGrid: View {
    private let cols: Int = 3
    private let spacing: CGFloat = 10
    private let cellSize = CGSize(width: 250, height: 250)
    private var hexagonWidth: CGFloat { (cellSize.width / 2) * cos(.pi / 6) * 2 }
    
    let synthesizer: AVSpeechSynthesizer
    let words: [String]
        
    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: spacing), count: cols)

        //ScrollView(.vertical) {
        GeometryReader { geometryProxy in
            LazyVGrid(columns: gridItems, spacing: spacing) {
                ForEach(words, id: \.self) { word in
                    let idx = words.firstIndex(of: word)
                    WordCircle(wordText: word, synthesizer: synthesizer)
                        .frame(width: cellSize.width, height: cellSize.height * 2/3)
                        .offset(x: isEvenRow(idx) ? 0 : -1 * (hexagonWidth / 2 + (spacing/2)))
                }
            }
        }
    }
    
    func isEvenRow(_ idx: Int?) -> Bool {
        guard let idx = idx else { return false }
        return (idx / cols) % 2 == 0
    }
}

#Preview {
    ContentView(synthesizer: AVSpeechSynthesizer(), wordsOnCanvas: ["bed", "mom", "the", "by", "bus", "big", "mat"])
}
