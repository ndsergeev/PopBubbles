//
//  ContentView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SpriteKit
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var prefs: Prefs

    // Probably it is better to put this init in the AppDelegate
    var body: some View {
        if prefs.lastPlayerName.isEmpty {
            print("That is \(prefs.lastPlayerName)")
            return AnyView(LoginView())
        } else {
            print("That is \(prefs.lastPlayerName)")
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
                        self.selection = 1
                        self.prefs.lastPlayerName = self.nickname
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
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Spacer()
                
                Group {
                    Text("\(self.prefs.lastPlayerName),")
                    Text("your last score is \(self.prefs.lastScore)")
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
                
                NavigationLink(destination: GameSwiftUIView()) {
                        Text("Start Game")
                }
                    .hiddenNavigationBarStyle()
                    .foregroundColor(Color.red)
                    .padding()
                    .background(Color(.green))
                    .cornerRadius(4.0)
                    .padding(Edge.Set.vertical, 20)
                
                Spacer()
            }
        }
    }
}

struct GameSwiftUIView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        GameView()
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.darkGray).edgesIgnoringSafeArea(.all))
        .overlay(
             VStack {
                HStack {
                    Text("Score: \(self.prefs.lastScore)")

                    Spacer()

                    Button(action: { self.prefs.lastScore += 1 }) {
                        Text("Game")
                    }
                }
                .padding(20)
                .foregroundColor(.white)
                .background(Color(.clear))

                Spacer()
            }
        )
    }
}

struct AnotherView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        VStack {
            Button(action: { self.prefs.lastScore += 1 }) {
                Text("PRESS ME")
            }
            
            NavigationLink(destination: StartView()) {
                Text("Score: \(self.prefs.lastScore)")
            }
            .hiddenNavigationBarStyle()
            .foregroundColor(Color.red)
            .padding()
            .background(Color(.green))
            .cornerRadius(4.0)
            .padding(Edge.Set.vertical, 20)
        }
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
        ContentView().environmentObject(prefs)
    }
}
#endif
