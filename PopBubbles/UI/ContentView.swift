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
        if prefs.lastPlayerName.isEmpty || prefs.allPlayers.isEmpty {
            return AnyView(LoginView())
        } else {
            return AnyView(StartView())
        }
    }
}

struct StartView: View {
    @EnvironmentObject var prefs: Prefs
    @State var selection: Int? = nil
    @State var isPressedLogOut: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    NavigationLink(destination: LoginView(), tag: 0, selection: self.$selection) {
                        Text("")
                    }.hiddenNavigationBarStyle()
                    
                    Button(action: { self.isPressedLogOut = true }) {
                        HStack {
                            Image(systemName: "arrow.uturn.left.circle")
                            Text("logout")
                        }.font(.system(size: 24))
                    }.alert(isPresented: $isPressedLogOut) {
                        Alert(title: Text("Log out").bold(),
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
                    Slider(value: self.$prefs.gameplayTimeSlider, in: 0...60, step: 5)
                    Text("\(self.prefs.gameplayTimeSlider, specifier: "%.f")")
                }.padding(20)
                
                // hardcoded range [2]
                HStack {
                    Slider(value: self.$prefs.bubbleNumberSlider, in: 0...15, step: 1)
                    Text("\(self.prefs.bubbleNumberSlider, specifier: "%.f")")
                }.padding(20)
                
                Spacer()
                
                NavigationLink(destination: GameViewLayout(), tag: 2, selection: self.$selection) {
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

                Spacer()
            }
        }.hiddenNavigationBarStyle()
    }
}

// Navigation bar hider
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            // these two hide the navigation bar
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            // to make iPad view look same as iPhone view
            .navigationViewStyle(StackNavigationViewStyle())
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
