//
//  GuessView.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import SwiftUI

struct GuessView: View {
    @Binding var guess: Guess
    @EnvironmentObject var dm: WordleDataModel
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0...Int(dm.slider)-1, id: \.self) { index in
                Flip(isFlipped: $guess.cardFlipped[index]) {
                    Text(guess.guessLetters[index])
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .background(Color(red: 236/255, green: 234/255, blue: 187/255))
                } back: {
                    Text(guess.guessLetters[index])
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .background(guess.bgColors[index])
                }
                .font(.system(size: 35, weight: .heavy))
                .border(Color(.secondaryLabel))
            }
        }
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        GuessView(guess: .constant(Guess(index: 0)))
    }
}
