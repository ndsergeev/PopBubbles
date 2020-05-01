//
//  ContentView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SpriteKit
import SwiftUI

class UserSettings: ObservableObject {
    @Published var playerScore: Int = 0
//    @Published var sliderTimer: Double = 0
//    @Published var sliderNumber: Double = 0
}

struct ContentView: View {
    @EnvironmentObject var playerSettings: UserSettings
    
    var body: some View {
        StartWindow()
//        .background((Color.red).edgesIgnoringSafeArea(.all))
    }
}

struct StartWindow: View {
    @EnvironmentObject var playerSettings: UserSettings
    
    @State var sliderTimer: Double = 0
    @State var sliderNumber: Double = 0
    
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Text("Here we go again").font(.largeTitle)
                Text("Score \(self.playerSettings.playerScore)").font(.title)
                Button(action: {self.playerSettings.playerScore += 1}) {
                    Text("PRESS ME")
                }
                
                Spacer()
                
                HStack {
                    Slider(value: self.$sliderTimer, in: 0...60, step: 5)
                    Text("\(self.sliderTimer, specifier: "%.f")")
                }.padding(20)
                
                HStack {
                    Slider(value: self.$sliderNumber, in: 0...15, step: 5)
                    Text("\(self.sliderNumber, specifier: "%.f")")
                }.padding(20)
                
                NavigationLink(destination: GameSwiftUIView()) {
                        Text("Start Game")
                }.frame(width: 200, height: 20, alignment: .center)
                .transition(.offset())
                .hiddenNavigationBarStyle()
                .foregroundColor(Color.red)
                .padding()
                .background(Color(.green))
                .cornerRadius(4.0)
                .padding(Edge.Set.vertical, 20)
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: GameSwiftUIView()) {
                            Text("Start Game")
                    }.transition(.offset())
                    .hiddenNavigationBarStyle()
                    .accentColor(.blue)
                    .padding()
                    .background(Color(.green))
                    .cornerRadius(4.0)
                    .padding(Edge.Set.vertical, 20)
                    
                    Spacer()
                    
                    NavigationLink(destination: Stats()) {
                            Text("Leaderboard")
                    }.transition(.offset())
                    .hiddenNavigationBarStyle()
                    .accentColor(.blue)
                    .padding()
                    .background(Color(.green))
                    .cornerRadius(4.0)
                    .padding(Edge.Set.vertical, 20)
                }
                .padding(Edge.Set.horizontal, 20)
            }
        }
    }
}

struct GameSwiftUIView: View {
    @EnvironmentObject var playerSettings: UserSettings
    
    var body: some View {
        GameView()
        .environmentObject(playerSettings)
        .overlay(
             VStack {
                HStack {
                    Text("Score: \(self.playerSettings.playerScore, specifier: "%.f")")
                    Spacer()
                    Button(action: { self.playerSettings.playerScore += 1 }) {
                        Text("Game")
                    }
                }.padding(20)
                .foregroundColor(.white)
                .background(Color(.clear))
                
                Spacer()
            }
        )
        .environmentObject(playerSettings)
    }
}

struct Stats: View {
    @EnvironmentObject var playerSettings: UserSettings
    var body: some View {
        VStack {
            Text("Leaderboard \"\(playerSettings.playerScore)\"")
            
            Button(action: {self.playerSettings.playerScore += 1}){Text("INCREASE \(playerSettings.playerScore)")}
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

let playerSettings = UserSettings()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(playerSettings)
    }
}
#endif

