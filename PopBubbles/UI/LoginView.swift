//
//  LoginView.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 18/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

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
                
                HStack {
                    Text("PoPit ")
                    Text("🎈").animation(Animation.interactiveSpring(response: 3, dampingFraction: 0.1, blendDuration: 1))
                }.font(.system(size: 48))
                
                Spacer()
                
                Text("Time to pop some bubbles?!")
                    .font(.title)
                
                TextField("Enter Your Name", text: textFieldBinding)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text(self.showErrorMessage ? "Please, fill your name to continue" : " ")
                    .foregroundColor(.red)
            
                Spacer()
                
                NavigationLink(destination: StartView(), tag: 0, selection: self.$selection) {
                    Text("")
                }.hiddenNavigationBarStyle()
                
                Button(action: {
                    if self.canNavigate == true {
                        self.prefs.lastPlayerName = self.nickname
                        self.selection = 0
                    }
                }) {
                    Text("Next")
                        .font(.title)
                        .foregroundColor(self.canNavigate ? .blue : .gray)
                }.disabled(!self.canNavigate)
                
                Spacer()
            }
        }.hiddenNavigationBarStyle()
    }
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(prefs)
    }
}
#endif
