//
//  RatingView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 17/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @EnvironmentObject var prefs: Prefs
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.selection = 0
                    }) {
                        Text("Menu")
                    }
                    
                    Spacer()
                    
                    Text("Champions")
                    
                    Spacer()
                    
                    Button(action: {
                        self.prefs.ClearRecords()
                    }) {
                        Text("Clear")
                    }
                }.font(.title)
                .padding()
                
                Spacer()
                
                if prefs.allPlayers.count > 0 {
                    List(prefs.allPlayers) { player in
                        HStack {
                            Text("\(player.name)")
                            Spacer()
                            Text("\(player.highScore)")
                        }.padding(10)
                    }
                } else {
                    Text("There are no records")
                        .font(.title)
                    Spacer()
                }
            }
        }
    }
}
