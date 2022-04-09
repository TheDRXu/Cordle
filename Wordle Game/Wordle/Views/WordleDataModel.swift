//
//  WordleDataModel.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import SwiftUI

class WordleDataModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    @Published var slider: Double = 6
    @Published var toggleAlert: Bool = false
    @Published var toggleWin: Bool = false
    @Published var toggleLose: Bool = false
    @Published var popUpText: String?
    @Published var showStats = false
    
    var gameOver = false
    var keyColors = [String : Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    var currentStat: Statistic
    
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool {
        !inPlay || currentWord.count == Int(slider)
    }
    
    var disabledSlider: Bool{
        currentWord.count > 0
    }
    
    init() {
        currentStat = Statistic.loadStat()
        newGame()
    }
    
    func newGame() {
        defaultfunc()
        if slider == 4 {
            selectedWord = Global.country4letters.randomElement()!
        }
        else if slider == 5 {
            selectedWord = Global.country5letters.randomElement()!
        }
        else{
            selectedWord = Global.country6letters.randomElement()!
        }
        print(selectedWord)
        currentWord = ""
        inPlay = true
        tryIndex = 0
        gameOver = false
    }
    
    func defaultfunc() {
        guesses = []
        for index in 0...Int(slider)+2 {
            guesses.append(Guess(index: index))
        }
        // reset keyboard colors
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused
        }
        matchedLetters = []
        misplacedLetters = []
    }
    
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        playSound(sound: "key", type: "wav")
        updateRow()
    }
    
    func enterWord() {
        if currentWord == selectedWord{
            gameOver = true
            toggleWin = true
            print("You win!")
            setCurrentGuess()
            currentStat.update(win: true, index: tryIndex)
            inPlay = false
            playSound(sound: "correct", type: "mp3")
        }
        else{
            if verifyWord() {
                print("Valid word")
                setCurrentGuess()
                tryIndex+=1
                currentWord = ""
                if tryIndex < 6{
                    playSound(sound: "ans", type: "mp3")
                }
                if tryIndex == 6{
                    currentStat.update(win: false)
                    gameOver = true
                    toggleLose = true
                    inPlay = false
                    print("You lose")
                }
            } else {
                withAnimation {
                    self.incorrectAttempts[tryIndex] += 1
                }
                incorrectAttempts[tryIndex] = 0
                toggleAlert = true
                playSound(sound: "wrong", type: "mp3")
            }
        }
    }
    
    func removeLetterFromCurrentWord() {
        currentWord.removeLast()
        updateRow()
    }
    
    func updateRow() {
        let guessWord = currentWord.padding(toLength: Int(slider), withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }
    
    func verifyWord() -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord)
    }
    
    func setCurrentGuess(){
        print(selectedWord)
        let correctLetters = selectedWord.map { String($0) }
        var frequency = [String : Int]()
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }
        for index in 0...Int(slider)-1{
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if guessLetter == correctLetter {
                guesses[tryIndex].bgColors[index] = .correct
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}) {
                        misplacedLetters.remove(at: index)
                    }
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...Int(slider)-1 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correct
                && frequency[guessLetter]! > 0 {
                guesses[tryIndex].bgColors[index] = .misplaced
                if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter) {
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplaced
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...Int(slider)-1 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if keyColors[guessLetter] != .correct
                && keyColors[guessLetter] != .misplaced {
                keyColors[guessLetter] = .wrong
            }
        }
        flipCards(for: tryIndex)
    }
    func flipCards(for row: Int){
        for col in 0...Int(slider)-1{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col)*0.2){
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }
    
    func shareResult() {
        let stat = Statistic.loadStat()
        let results = guesses.enumerated().compactMap { $0 }
        var guessString = ""
        for result in results {
            if result.0 <= tryIndex {
                guessString += result.1.results + "\n"
            }
        }
        let resultString = """
Wordle \(stat.games) \(tryIndex < 6 ? "\(tryIndex + 1)/6" : "")
\(guessString)
"""
        print(resultString)
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2,
                                                                                  y: Global.screenHeight / 2,
                                                                                  width: 200,
                                                                                  height: 200)
            UIWindow.key?.rootViewController!.present(activityController, animated: true)
        default:
            break
        }
    }
}
