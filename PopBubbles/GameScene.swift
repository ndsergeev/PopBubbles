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
    // Variable under Observer, it is shared with SwiftUI
    var prefs: Prefs?
    
    // Array of custom SKShapeNodes
    var bubbles: [Bubble] = [Bubble]()
    
    // Use for splitting the view in sectors to random
    // bubble spawn within each one
    var cells: [CGRect] = [CGRect]()
    
    private var lastUpdateTime: TimeInterval = 0
    private var bubbleExistsTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // moved from here to init(CGSize, Prefs)
    }
    
    init(size: CGSize, prefs: Prefs) {
        super.init(size: size)
        self.prefs = prefs

        // receiving from the number of Bubbles from Slider
        backgroundColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
            
            calcCellSizes(number: Int(prefs!.bubbleNumberSlider))
            
            // it also inits animation (SKAction) inside
            spawnBubbles(number: Int(prefs!.bubbleNumberSlider))
        }
        
        // HERE YOU SHOULD FINISH THE GAME IF THE TIMER IS OVER
        
        let delta = currentTime - self.lastUpdateTime
        self.bubbleExistsTime += delta
        
        if self.bubbleExistsTime > 5 {
            if !bubbles.isEmpty {
                for bubble in bubbles {
                    bubble.removeFromParent()
                }
            }
            
            spawnBubbles(number: Int(prefs!.bubbleNumberSlider))
            
            self.bubbleExistsTime = 0
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func splitInCells(x: Int, y: Int) -> Void {
        let height: Int = Int(self.size.height) / y
        let width: Int = Int(self.size.width) / x
        
        for iY in 0..<y { // height
            for iX in 0..<x { // width
                cells.append(CGRect(x: Int(CGFloat(iX * width) + 1), y: Int(CGFloat(iY * height) + 1), width: width, height: height))
            }
        }
    }
    
    func calcCellSizes(number: Int) -> Void {
        switch number {
        case 1...3:
            splitInCells(x: 1, y: number)
        case 4...8:
            splitInCells(x: 2, y: (number + 1) / 2)
        case 9...12:
            splitInCells(x: 3, y: 4)
        case 13...16:
            splitInCells(x: 4, y: 4)
        default:
            break
        }
    }
    
    func randBubblePositionInCell(cell: CGRect, radius: CGFloat) -> CGPoint {
        // Function calculates position of a bubble based on cell's size
        // Probably need to check that it isn't nil
        let x = CGFloat.random(in: (cell.minX + radius)...(cell.maxX - radius))
        let y = CGFloat.random(in: (cell.minY + radius)...(cell.maxY - radius))
        return CGPoint(x: x, y: y)
    }
    
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
    
    func spawnBubbles(number: Int) -> Void {
        var cellsCopy = cells
        let diff = cellsCopy.count-number

        if diff > 0 {
            for _ in 0..<diff {
                cellsCopy.remove(at: Int.random(in: 0..<cellsCopy.count))
            }
        }
        
        for cell in cellsCopy {
            let bubRad = bubbleRadius()
            let bub = Bubble(col: randBubbleColor(), pos: randBubblePositionInCell(cell: cell, radius: bubRad), rad: bubRad)
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
