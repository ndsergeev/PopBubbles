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

    var body: some View {
        if prefs.lastPlayerName.isEmpty {
            return AnyView(LoginView())
        } else {
            return AnyView(HelloView())
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var prefs: Prefs
    @State var nickname: String = ""
    @State var isFilled: Bool = false
    @State var showErrorMessage: Bool = false
    @State var navigationIsActive: Bool = false
    
    var body: some View {
        let textFieldBinding = Binding<String>(get: {
            self.nickname
        }, set: {
            self.nickname = $0
            self.showErrorMessage = self.nickname.isEmpty ? true : false
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
                
                
                if self.nickname == "" {
                    NavigationLink("Next", destination: StartView(), isActive: $navigationIsActive)
                    .hiddenNavigationBarStyle()
                    .font(.title)
                    .foregroundColor(.gray)
                } else {
                    // move on case
                    NavigationLink("Next", destination: StartView(), isActive: $navigationIsActive)
                        .hiddenNavigationBarStyle()
                        .font(.title)
                }
//                if self.nickname == "" {
//                    Button(action: {
//                        if self.nickname == "" {
//                            self.showErrorMessage = true
//                        }
//                    }, label: {
//                        NavigationLink("Next", destination: StartView(), isActive: $navigationIsActive)
//                            .hiddenNavigationBarStyle()
//                            .font(.title)
//                            .foregroundColor(.gray)
//
//                    })
//                } else {
//                    // move on case
//                    NavigationLink("Next", destination: StartView(), isActive: $navigationIsActive)
//                        .hiddenNavigationBarStyle()
//                        .font(.title)
//                }
                
                Spacer()
            }
        }
    }
}

struct HelloView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        Text("Hello, \(self.prefs.lastPlayerName)")
    }
}


struct StartView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Hello, \(self.prefs.lastPlayerName)!")
                Text("Your last score: \(self.prefs.lastScore)").font(.title)
                Button(action: { self.prefs.lastScore += 1 }) {
                    Text("PRESS ME")
                }
                
                HStack {
                    Slider(value: self.$prefs.gameplayTimeSlider, in: 0...60, step: 5)
                    Text("\(self.prefs.gameplayTimeSlider, specifier: "%.f")")
                }.padding(20)
                
                HStack {
                    Slider(value: self.$prefs.bubbleNumberSlider, in: 0...15, step: 1)
                    Text("\(self.prefs.bubbleNumberSlider, specifier: "%.f")")
                }.padding(20)
                
                NavigationLink(destination: GameSwiftUIView()) {
                        Text("Start Game")
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
}

struct GameSwiftUIView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        GameView()
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
