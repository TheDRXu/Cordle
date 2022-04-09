//
//  Guess.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import SwiftUI

struct Guess {
    let index: Int
    var word = "       "
    var bgColors = [Color](repeating: .wrong, count: 6)
    var cardFlipped = [Bool](repeating: false, count: 6)
    var guessLetters: [String] {
        word.map { String($0) }
    }
    
    var results: String {
        let tryColors: [Color : String] = [.misplaced : "🟨", .correct : "🟩", .wrong : "⬛"]
        return bgColors.compactMap {tryColors[$0]}.joined(separator: "")
    }
}
