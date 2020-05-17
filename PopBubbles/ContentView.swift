//
//  ContentView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var prefs: Prefs

    // Probably it is better to put this init in the AppDelegate
    var body: some View {
        if prefs.lastPlayerName.isEmpty {
//            print("That is \(prefs.lastPlayerName)")
            return AnyView(LoginView())
        } else {
//            print("That is \(prefs.lastPlayerName)")
            return AnyView(StartView())
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var prefs: Prefs
    @State var nickname: String = ""
    @State var isFilled: Bool = false
    @State var showErrorMessage: Bool = false
    @State var canNavigate: Bool = false
    @State var selection : Int? = nil
    
    var body: some View {
        let textFieldBinding = Binding<String>(get: {
            self.nickname
        }, set: {
            self.nickname = $0
            if self.nickname.isEmpty {
                self.showErrorMessage = true
                self.canNavigate = false
            } else {
                self.showErrorMessage = false
                self.canNavigate = true
            }
        })
        
        return NavigationView {
            VStack {
                Spacer()
                
                Text("PoPit 🎈").font(.system(size: 48))
                
                Spacer()
                
                Text("Time to pop some bubbles?!")
                    .font(.title)
                
                TextField("Enter Your Name", text: textFieldBinding)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(self.showErrorMessage ? "Please, fill your name to continue" : " ")
                    .foregroundColor(.red)
            
                Spacer()
                
                NavigationLink(destination: StartView(), tag: 1, selection: self.$selection) {
                    Text("")
                }.hiddenNavigationBarStyle()
                
                Button(action: {
                    if self.canNavigate == true {
                        self.prefs.lastPlayerName = self.nickname
                        self.selection = 1
                    }
                }) {
                    Text("Next")
                        .font(.title)
                        .foregroundColor(self.canNavigate ? .blue : .gray)
                }
                
                Spacer()
            }
        }
    }
}

struct StartView: View {
    @EnvironmentObject var prefs: Prefs
    @State var selection: Int? = nil
    @State var logoutAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    NavigationLink(destination: LoginView(), tag: 0, selection: self.$selection) {
                        Text("")
                    }.hiddenNavigationBarStyle()
                    
                    Button(action: { self.logoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.uturn.left.circle")
                            Text("logout")
                        }.font(.system(size: 24))
                    }.alert(isPresented: $logoutAlert) {
                        Alert(title: Text("Log out"),
                              message: Text("Are you sure?"),
                              primaryButton: .cancel(),
                              secondaryButton: .destructive(Text("Log out")) {
                                self.selection = 0
                        })
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: RatingView(), tag: 1, selection: self.$selection) {
                        Text("")
                    }.hiddenNavigationBarStyle()
                    
                    Button(action: {
                        self.selection = 1
                    }) {
                        HStack {
                            Text("rating")
                            Image(systemName: "chart.bar")
                        }.font(.system(size: 24))
                    }
                }.padding(24)
                
                Spacer()
                
                Group {
                    Text("\(self.prefs.lastPlayerName)").font(.largeTitle)
                    Text("Highest Score: \(self.prefs.highestScore)")
                }.font(.title)
                
                // hardcoded range [1]
                HStack {
                    Slider(value: self.$prefs.gameplayTimeSlider, in: 5...60, step: 5)
                    Text("\(self.prefs.gameplayTimeSlider, specifier: "%.f")")
                }.padding(20)
                
                // hardcoded range [2]
                HStack {
                    Slider(value: self.$prefs.bubbleNumberSlider, in: 1...15, step: 1)
                    Text("\(self.prefs.bubbleNumberSlider, specifier: "%.f")")
                }.padding(20)
                
                Spacer()
                
                NavigationLink(destination: GameSwiftUIView(), tag: 2, selection: self.$selection) {
                    Text("")
                }.hiddenNavigationBarStyle()
                
                Button(action: { self.selection = 2 }) {
                    Text("START")
                    .padding()
                }.font(.system(size: 24))
                .padding(Edge.Set.horizontal, 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(4.0)
                .disabled(prefs.bubbleNumberSlider < 1 || prefs.gameplayTimeSlider < 5)

                Spacer()
            }
        }
    }
}

struct GameSwiftUIView: View {
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
                                .padding(20)
                        } else {
                            Text("Your time is over ⏱")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                        }
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.prefs.UpdatePlayer(nickname: self.prefs.lastPlayerName)
                        }) {
                            Text("TO MENU")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(20)
                                .background(Color.blue)
                                .cornerRadius(4.0)
                        }
                    }.padding(30)
                        .background(Color.green)
                }
                Spacer()
            }
        ).background(Color(.gray))
    }
}

// Navigation bar hider
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        ModifiedContent(content: self, modifier: HiddenNavigationBar())
    }
}

#if DEBUG
let prefs = Prefs()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView().environmentObject(prefs)
    }
}
#endif
