//
//  GameViewController.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    @EnvironmentObject var prefs: Prefs
    
    class Coordinator: NSObject {
        var scene: SKScene?
        var prefs: Prefs
        
        init(prefs: Prefs) {
            self.prefs = prefs
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(prefs: self.prefs)
    }

    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)

        view.preferredFramesPerSecond = 60
        
        // These two lines to comment
        view.showsFPS = true
        view.showsNodeCount = true

        let mainScene = SKGameScene(size: view.bounds.size, prefs: context.coordinator.prefs)

        mainScene.scaleMode = .resizeFill
        context.coordinator.scene = mainScene
        
        return view
    }

    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}
