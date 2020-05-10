//
//  GameScene.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import SpriteKit

class SKGameScene: SKScene {
    var prefs: Prefs?
    
    var bubbles: [Bubble] = [Bubble]()
    
    private var lastUpdateTime: TimeInterval = 0
    private var bubbleExistsTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
    }
    
    init(size: CGSize, prefs: Prefs) {
        super.init(size: size)
        self.prefs = prefs
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
            
            // it also inits animation (SKAction) inside
            spawnBubbles(number: Int(prefs!.bubbleNumberSlider))
            print("HERE IT IS: \(prefs!.bubbleNumberSlider)")
        }
        
        let delta = currentTime - self.lastUpdateTime
        self.bubbleExistsTime += delta
        
        if self.bubbleExistsTime > 5 {
            if !bubbles.isEmpty {
                for bubble in bubbles {
                    bubble.removeFromParent()
                }
            }
            
            spawnBubbles(number: 10)
            
            self.bubbleExistsTime = 0
        }
        
        self.lastUpdateTime = currentTime
    }
    
    // Other methods:
    func randBubbleColor() -> BubbleColor {
        // Function randomises colors
        // see BubbleColor's comments
        let chance = Int.random(in: 0...19)
        
        switch chance {
        case 0..<8:
            return .red
        case 8..<14:
            return .pink
        case 14..<17:
            return .green
        case 17..<19:
            return .blue
        case 19:
            return .black
        default: //
            print("The chance color: \(chance) is out or the range")
            return .red
        }
    }
    
    func bubbleRadius() -> CGFloat {
        let rangeFrom = (view?.bounds.width)! / 16
        let rangeTo = (view?.bounds.width)! / 12
        return CGFloat.random(in: rangeFrom...rangeTo)
    }
    
    func randBubblePosition(radius: CGFloat) -> CGPoint {
        let x = CGFloat.random(in: ((view?.bounds.minX)! + radius)...((view?.bounds.maxX)! - radius))
        let y = CGFloat.random(in: ((view?.bounds.minY)! + radius)...((view?.bounds.maxY)! - radius))
        return CGPoint(x: x, y: y)
    }
    
    func spawnBubbles(number: Int) -> Void {
        for _ in 0..<number {
            let bubRad = bubbleRadius()
            let bub = Bubble(col: randBubbleColor(), pos: randBubblePosition(radius: bubRad), rad: bubRad)
            self.bubbles.append(bub!)
            self.addChild(bub!)
            animateBubble(bubble: bub!)
        }
    }
    
    func animateBubble(bubble: Bubble) {
        let animPath = SKAction.follow((bubble.animPath)!, asOffset: false, orientToPath: true, duration: 8)
        let repeatSequence = SKAction.repeatForever(SKAction.sequence([animPath, animPath.reversed()]))
        bubble.run(repeatSequence)
    }
}

#if os(iOS)
// Touch-based event handling
extension SKGameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            for node in self.bubbles {
                if node.contains(location) {
                    self.prefs?.lastScore += Int(node.gamePoints)
                    node.removeFromParent()
                }
            }
        }
    }
}
#endif
