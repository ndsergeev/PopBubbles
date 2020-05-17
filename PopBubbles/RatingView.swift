//
//  RatingView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 17/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

//struct RatingElement {
//    var body: some View {
//        HStack {
//            Text("")
//            Spacer()
//            Text("")
//        }.padding()
//    }
//}

struct RatingView: View {
    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Champions").font(.largeTitle)
                }
                
                Spacer()
                
//                List(prefs.players) { player in
//                    HStack {
//                        Text("\(player.name)")
//                        Spacer()
//                        Text("\(player.highScore)")
//                    }.padding(10)
//                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
