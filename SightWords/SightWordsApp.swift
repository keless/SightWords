//  Copyright © 2023 Apple Inc. All rights reserved.

import SwiftUI

import AVFoundation

@main
struct SightWordsApp: App {

    let synthesizer = AVSpeechSynthesizer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(synthesizer: synthesizer, wordsOnCanvas: [])
        }
    }
}
