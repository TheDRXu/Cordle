//
//  Keyboard.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//
import SwiftUI

struct Keyboard: View {
    @EnvironmentObject var dm: WordleDataModel
    var topRow = "QWERTYUIOP".map{ String($0) }
    var midRow = "ASDFGHJKL".map{ String($0) }
    var bottomRow = "ZXCVBNM".map{ String($0) }
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(topRow, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
            }
            HStack(spacing: 2) {
                ForEach(midRow, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
            }
            HStack(spacing: 2) {
                Button {
                    dm.enterWord()
                } label: {
                    Text("Enter")
                }
                .font(.system(size: 15))
                .frame(width: 50, height: 50)
                .foregroundColor(.black)
                .background(Color(red: 237/255, green: 143/255, blue: 179/255))
                .disabled(dm.currentWord.count < Int(dm.slider) || !dm.inPlay)
                ForEach(bottomRow, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(dm.disabledKeys)
                .opacity(dm.disabledKeys ? 0.6 : 1)
                Button {
                    dm.removeLetterFromCurrentWord()
                } label: {
                    Image(systemName: "delete.backward")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .background(Color(red: 237/255, green: 143/255, blue: 179/255))
                }
                .disabled(!dm.inPlay || dm.currentWord.count == 0)
            }
        }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
            .environmentObject(WordleDataModel())
            .scaleEffect(Global.keyboardScale)
    }
}
