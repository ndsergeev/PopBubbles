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
    
    var body: some View {
        GameView()
        .onAppear( perform: { self.localHighestScore = self.prefs.highestScore } )
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.darkGray).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(false)
        .overlay(
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
        ).overlay(
            VStack {
                Spacer()
                if self.prefs.gameIsPaused {
                    VStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.prefs.gameIsPaused.toggle()
                        }) {
                            Text("FINISH")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
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
                                self.prefs.UpdatePlayer(nickname: self.prefs.lastPlayerName)
                                self.prefs.UpdateHighScore(nickname: self.prefs.lastPlayerName, newHighScore: self.prefs.highestScore)
                            }) {
                                Text("MENU")
                                    .font(.title)
                                    .frame(width: 100, height: 40)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.blue)
                                    .cornerRadius(4.0)
                            }
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                self.prefs.UpdatePlayer(nickname: self.prefs.lastPlayerName)
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
        ).background(Color(.gray))
    }
}
