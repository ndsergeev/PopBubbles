//
//  GameViewController.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import UIKit
import SwiftUI
import SpriteKit
import GameplayKit

struct GameView: UIViewRepresentable {
    @EnvironmentObject var userSettings: UserSettings
    
    class Coordinator: NSObject {
        var scene: SKScene?
        var userSettings: UserSettings
        
        init(settings: UserSettings) {
            self.userSettings = settings
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(settings: self.userSettings)
    }

    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.showsFPS = true
        view.showsNodeCount = true
        
        print("\nScore is \(context.coordinator.userSettings.playerScore)\n")

        let mainScene = SKGameScene(size: view.bounds.size, settings: context.coordinator.userSettings)
        mainScene.scaleMode = .resizeFill
        context.coordinator.scene = mainScene
        return view
    }

    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}

class GameViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKGameScene(size: view.bounds.size, settings: userSettings)

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
