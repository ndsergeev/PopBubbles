//
//  GameViewLayout.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 18/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

struct GameViewLayout: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var prefs: Prefs
    @State var selection: Int? = nil
    @State var localHighestScore: Int = 0
    @State var isPressedFinish: Bool = false
    
    var body: some View {
        GameView()
        .onAppear( perform: {
            self.localHighestScore = self.prefs.highestScore
        } )
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.darkGray).edgesIgnoringSafeArea(.all))
        .hiddenNavigationBarStyle()
        .overlay(
            GameStatsView()
        ).overlay(
            VStack {
                Spacer()
                if self.prefs.gameIsPaused && !self.prefs.gameIsOver {
                    VStack {
                        Button(action: { self.isPressedFinish = true }) {
                            Text("FINISH")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                        }.alert(isPresented: $isPressedFinish) {
                            Alert(title: Text("Warning").bold(),
                                  message: Text("You'll lose your current progress if you leave now"),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Leave")) {
                                    // In case of finishing the game before the timer
                                    // your progress is lost
                                    self.prefs.highestScore = self.localHighestScore
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.prefs.gameIsPaused.toggle()
                            })
                        }
                        
                        Button(action: {
                            self.prefs.gameIsPaused.toggle()
                        }) {
                            Text("RESUME")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }.padding(30)
                        .background(Color.green)
                } else if self.prefs.gameIsOver {
                    VStack {
                        if prefs.lastScore > self.localHighestScore {
                            Group {
                                Text("Broke the ceiling!")
                                    .bold()
                                Text("High Score: \(prefs.lastScore)")
                                Text("Before: \(self.localHighestScore)")
                            }.foregroundColor(.white)
                                .font(.title)
                                .padding(10)
                        } else {
                            Text("Your time is over ⏱")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                        }
                        
                        
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                self.GloballyUpdateHighScore()
                                
                                self.prefs.recordLatestPlayerStats(nickname: self.prefs.lastPlayerName)
                                self.prefs.updateHighScoreForPlayer(nickname: self.prefs.lastPlayerName, newHighScore: self.prefs.highestScore)
                            }) {
                                Text("MENU")
                                    .font(.title)
                                    .frame(width: 100, height: 40)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.blue)
                                    .cornerRadius(4.0)
                            }
                            
                            NavigationLink(destination: RatingView(), tag: 0, selection: self.$selection) {
                                Text("")
                            }.hiddenNavigationBarStyle()
                            
                            Button(action: {
//                                self.presentationMode.wrappedValue.dismiss()
                                self.GloballyUpdateHighScore()
                                
                                self.prefs.recordLatestPlayerStats(nickname: self.prefs.lastPlayerName)
                                self.selection = 0
                            }) {
                                Text("SCORE")
                                    .font(.title)
                                    .frame(width: 100, height: 40)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.blue)
                                    .cornerRadius(4.0)
                            }
                        }
                    }.padding(30)
                        .background(Color.green)
                }
                Spacer()
            }
        )
    }
    
    func GloballyUpdateHighScore() {
        self.prefs.updateHighScoreForPlayer(nickname: self.prefs.lastPlayerName, newHighScore: self.prefs.highestScore)
    }
}

struct GameStatsView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Highest: \(self.prefs.highestScore)")
                    Text("Current: \(self.prefs.lastScore)")
                }

                Spacer()
                
                Text("⏱: \(self.prefs.timer,  specifier: "%.f")s")
                    .font(.largeTitle)
                
                Spacer()

                Button(action: {
                    self.prefs.gameIsPaused.toggle()
                }) {
                    Text("PAUSE")
                        .padding(10)
                }.disabled(prefs.gameIsOver)
                    .background(self.prefs.gameIsOver ? Color.gray : Color.blue)
                    .cornerRadius(4.0)
            }.padding(20)
                .foregroundColor(.white)
                .background(Color(.clear))

            Spacer()
        }
    }
}

#if DEBUG

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(prefs)
    }
}
#endif
