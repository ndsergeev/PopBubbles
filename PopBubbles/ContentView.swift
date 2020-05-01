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
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        StartView()
    }
}

struct StartView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Here we go again").font(.largeTitle)
                Text("Score \(self.userSettings.playerScore)").font(.title)
                Button(action: {self.userSettings.playerScore += 1}) {
                    Text("PRESS ME")
                }
                
                NavigationLink(destination: GameSwiftUIView()) {
                        Text("Start Game")
                }
                .hiddenNavigationBarStyle()
                .transition(.opacity)
                .foregroundColor(Color.red)
                .padding()
                .background(Color(.green))
                .cornerRadius(4.0)
                .padding(Edge.Set.vertical, 20)
                
                NavigationLink(destination: AnotherView()) {
                        Text("ANOTHER")
                }
                .transition(.offset())
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
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        GameView()
        .overlay(
             VStack {
                HStack {
                    Text("Score: \(self.userSettings.playerScore)")

                    Spacer()

                    Button(action: { self.userSettings.playerScore += 1 }) {
                        Text("Game")
                    }
                }
                .environmentObject(userSettings)
                .padding(20)
                .foregroundColor(.white)
                .background(Color(.clear))

                Spacer()
            }
        )
    }
}

struct AnotherView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack {
            Button(action: {self.userSettings.playerScore += 1}) {
                Text("PRESS ME")
            }
            
            NavigationLink(destination: StartView()) {
                    Text("Score: \(self.userSettings.playerScore)")
            }
            .transition(.offset())
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
let userSettings = UserSettings()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(userSettings)
    }
}
#endif

