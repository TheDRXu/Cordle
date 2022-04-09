//
//  GameView.swift
//  WordleGame
//
//  Created by Dwayne Reinaldy on 3/30/22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm: WordleDataModel
    @State private var showAlert = false
    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                    HStack{
                        Slider(value: $dm.slider, in: 4...6,step: 1)
                            .disabled(dm.disabledSlider)
                            .foregroundColor(Color.unused)
                        Text("\(Int(dm.slider))")
                            .foregroundColor(Color(red: 237/255, green: 143/255, blue: 179/255))
                    }
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.top)
                    .onChange(of: dm.slider, perform: { value in
                        if value == 4 {
                            dm.selectedWord = Global.country4letters.randomElement()!
                        }
                        else if value == 5 {
                            dm.selectedWord = Global.country5letters.randomElement()!
                        }
                        else {
                            dm.selectedWord = Global.country6letters.randomElement()!
                        }
                    })
                    Spacer()
                    VStack(spacing: 3) {
                        ForEach(0...5, id: \.self) { index in
                            GuessView(guess: $dm.guesses[index])
                                .modifier(Shake(animatableData: CGFloat(dm.incorrectAttempts[index])))
                                .alert(isPresented: $dm.toggleAlert){
                                    Alert(title: Text("Wrong Input"), message: Text("Please enter a correct word"), dismissButton: .default(Text("OK")))
                                }
                        }
                        
                    }
                    .frame(width: Global.boardWidth, height: 6 * Global.boardWidth / 5)
                    Spacer()
                    Keyboard()
                        .scaleEffect(Global.keyboardScale)
                        .padding(.top)
                    Spacer()
                }
                    .background(Color(red: 18/255, green: 42/255, blue: 46/255))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack{
                                if !dm.inPlay{
                                    Button{
                                        dm.newGame()
                                    }label:{
                                        Image(systemName:"plus.square.fill")
                                            .foregroundColor(Color.misplaced)
                                    }
                                    .alert(isPresented: $dm.toggleWin){
                                        Alert(title: Text("You Win"), message: Text("Click new game to start again"), dismissButton: .default(Text("OK")))
                                    }
                                    
                                }
                            }
                            
                        }
                        ToolbarItem(placement: .principal) {
                            VStack{
                                HStack{
                                    Image(systemName: "flag.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(red: 237/255, green: 143/255, blue: 179/255))
                                    HStack{
                                        Text("C")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)

                                        Text("O")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)
                                        Text("R")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)
                                        Text("D")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)
                                        Text("L")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)
                                        Text("E")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.black)
                                            .background(Color.unused)
                                    }
                                    
                                    Image(systemName: "flag.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(red: 237/255, green: 143/255, blue: 179/255))
                                }
                                Text("Country Name Wordle")
                                    .foregroundColor(Color(red: 236/255, green: 234/255, blue: 187/255))
                            }
                            .alert(isPresented: $dm.toggleLose){
                                Alert(title: Text("You Lose"), message: Text("Click new game to start again"), dismissButton: .default(Text("OK")))
                            }
                            
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Button {
                                    withAnimation {
                                        dm.currentStat = Statistic.loadStat()
                                        dm.showStats.toggle()
                                    }

                                } label: {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(Color(red: 237/255, green: 143/255, blue: 179/255))
                                }
                            }
                        }
                        
                    }
            }
            
            .navigationViewStyle(.stack)
            if dm.showStats{
                StatsView()
            }
            
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
            .colorScheme(.dark)
    }
}
