//  Copyright © 2023 Apple Inc. All rights reserved.

import SwiftUI

@main
struct SightWordsApp: App {
    //zzz TODO: have a database of words
    
    var body: some Scene {
        WindowGroup {
            ContentView(listOfWords: [])
        }
    }
}
