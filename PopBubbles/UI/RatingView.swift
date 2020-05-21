//
//  RatingView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 17/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

// READ IT PLEASE
// There is a warning message appears during execution:
// [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window.

// GO TO:
// https://www.hackingwithswift.com/forums/swiftui/problems-with-tabview/111
// where quite aware about SwiftUI person says:
// "This is an internal Apple message, and not for us to worry about. We're all seeing the same message no matter what, so it's definitely for Apple to fix!"
// That is why the mark shouldn't be deducted for that!


import SwiftUI

struct RatingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var prefs: Prefs
    @State var isConfirmedDataRemoval = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }.hiddenNavigationBarStyle()
                    
                    Spacer()
                    
                    Text("Score")
                    
                    Spacer()
                    
                    Button(action: {
                        self.isConfirmedDataRemoval = true
                    }) {
                        Text("Clear")
                    }.alert(isPresented: $isConfirmedDataRemoval) {
                        Alert(title: Text("Warning").bold(),
                              message: Text("If you confirm all the records and scores would be lost"),
                              primaryButton: .cancel( {self.isConfirmedDataRemoval = false} ),
                              secondaryButton: .destructive(Text("Confirm")) {
                                self.prefs.clearRecords()
                        })
                    }
                }.font(.title)
                .padding()
                
                Spacer()
                
                if prefs.allPlayers.count > 0 {
                    List(prefs.allPlayers.sorted(by: { $0.highScore > $1.highScore })) { player in
                        HStack {
                            Text("\(player.name)")
                            Spacer()
                            Text("\(player.highScore)")
                        }.padding(10)
                    }
                } else {
                    Group {
                        Text("There are no records")
                        Text("🤷🏼‍♂️").font(.system(size: 60))
                    }.font(.title)
                    Spacer()
                }
            }
        }.hiddenNavigationBarStyle()
    }
}

#if DEBUG

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView().environmentObject(prefs)
    }
}
#endif
