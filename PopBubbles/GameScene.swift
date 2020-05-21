//
//  GameScene.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import SpriteKit

class BubbleInCell {
    var bubble: Bubble?
    var cell: CGRect?
    
    init(cell: CGRect, bubble: Bubble) {
        self.cell = cell
        self.bubble = bubble
    }
}

class SKGameScene: SKScene {
    // Variable under Observer, it is shared with SwiftUI
    let PI: CGFloat = CGFloat.pi / 8
    let upperOffsetCoeff: CGFloat = 0.9
    
    var prefs: Prefs?
    
    // Array of custom SKShapeNodes
    
    var numberOfRemovedBubbles: Int = 0
    
    // Use for splitting the view in sectors to random
    // bubble spawn within each one
    var bubbleHolder: [BubbleInCell] = [BubbleInCell]()
    
    var cells: [CGRect] = [CGRect]()
    
    private var gameWasPaused: Bool = false
    private var lastUpdateTime: TimeInterval = 0
    private var bubbleExistsTime: TimeInterval = 0
    
    private var previousBubbleColor: BubbleColor?
    
    override func didMove(to view: SKView) {
        // moved from here to init(CGSize, Prefs)
    }
    
    init(size: CGSize, prefs: Prefs) {
        super.init(size: size)
        self.prefs = prefs
        self.prefs!.gameIsPaused = false
        self.prefs!.gameIsOver = false
        self.prefs!.timer = self.prefs!.gameplayTimeSlider
        self.prefs!.lastScore = 0
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
        
        self.view?.isPaused = !self.prefs!.gameIsOver ? self.prefs!.gameIsPaused : true
        
        let delta = !gameWasPaused ? currentTime - self.lastUpdateTime : 0
        
        if !self.view!.isPaused {
            self.gameWasPaused = false
            self.prefs!.timer -= delta
            
            self.bubbleExistsTime += delta
            
            if self.bubbleExistsTime > 1 {
                
                removeAllBubbles()
                
                spawnBubbles(number: Int(prefs!.bubbleNumberSlider))
                
                self.bubbleExistsTime = 0
            }
        } else {
            self.gameWasPaused = true
        }
        
        if self.prefs!.timer <= 0.0 && !self.prefs!.gameIsOver {
            self.removeAllBubbles()
            
            self.prefs!.timer = 0
            self.prefs!.gameIsOver = true
            self.view!.isPaused = true
        }
        
        if !bubbleHolder.isEmpty {
            for item in bubbleHolder {
                if !item.bubble!.hasActions() {
                    self.animateBubbleContinously(bubble: item.bubble!)
                }
            }
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func removeAllBubbles() {
        // function removes all bubbles
        // from the scene
        if !bubbleHolder.isEmpty {
            for item in bubbleHolder {
                item.bubble?.removeFromParent()
            }
            bubbleHolder.removeAll()
        }
    }
    
    func splitInCells(x: Int, y: Int) {
        // function takes max possible number
        // of bubbles and efficiently splits the screen
        // into segments to spawn bubbles randomly
        
        // Coordinates and sizes of every segment (or cell)
        // are recorded as an element of 'cells' array
        
        let height: Int = Int(self.size.height * self.upperOffsetCoeff) / y
        let width: Int = Int(self.size.width) / x
        
        for iY in 0..<y { // height
            for iX in 0..<x { // width
                cells.append(CGRect(x: Int(CGFloat(iX * width) + 1), y: Int(CGFloat(iY * height) + 1), width: width, height: height))
            }
        }
    }
    
    func calcCellSizes(number: Int) {
        // hardcoded for the task of max 15 bubbles
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
        if !cells.isEmpty {
            var cellsCopy = cells
            // remove redundand bubbles
            // refer to calcCellSizes()
            let diff = cellsCopy.count-number
            if diff > 0 {
                for _ in 0..<diff {
                    cellsCopy.remove(at: Int.random(in: 0..<cellsCopy.count))
                }
            }
            
            // remove random number of bubbles
            for _ in cellsCopy {
                if Bool.random() {
                    cellsCopy.remove(at: Int.random(in: 0..<cellsCopy.count))
                }
            }
            
            for cell in cellsCopy {
                let bubRad = bubbleRadius()
                let position = randBubblePositionInCell(cell: cell, radius: bubRad)
                let bub = Bubble(col: randBubbleColor(), pos: position, rad: bubRad)
                bubbleHolder.append(BubbleInCell(cell: cell, bubble: bub!))
                
                self.addChild(bub!)
                animateBubbleOnAppear(bubble: bub!)
            }
        }
    }

    func animateBubbleOnAppear(bubble: Bubble) {
        let up: CGFloat = CGFloat(Float.random(in: 1.1...1.5))
        let down: CGFloat = CGFloat(Float.random(in: 0.5...0.9))
        
        let scaleUp = SKAction.scale(to: up, duration: 0.2)
        let scaleDown = SKAction.scale(to: down, duration: 0.2)
        let toNormal = SKAction.scale(to: 1, duration: 0.1)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown, toNormal])
        bubble.run(sequence)
    }
    
    func animateBubbleContinously(bubble: Bubble) {
        let animPath = SKAction.follow((bubble.animPath)!, asOffset: false, orientToPath: true, duration: TimeInterval(PI * bubble.radius!))
        let repeatSequence = SKAction.repeatForever(SKAction.sequence([animPath, animPath.reversed()]))
        bubble.run(repeatSequence)
    }
}

#if os(iOS)
// Touch-based event handling for iOS
// in case of MacOS there should be other implementation
extension SKGameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPaused {
            // if the game is paused touches outside shouldn't be counted
            return
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            for item in bubbleHolder {
                if item.bubble!.contains(location) {
                    
                    if item.bubble!.color == previousBubbleColor {
                        self.prefs!.lastScore += Int(((Double(item.bubble!.gamePoints) * 1.5)).rounded())
                    } else {
                        self.prefs!.lastScore += Int(item.bubble!.gamePoints)
                    }
                    
                    previousBubbleColor = item.bubble!.color
                    
                    item.bubble!.removeFromParent()
                    
                    if prefs!.highestScore < prefs!.lastScore {
                        prefs!.highestScore = prefs!.lastScore
                    }
                }
            }
        }
    }
}
#endif
