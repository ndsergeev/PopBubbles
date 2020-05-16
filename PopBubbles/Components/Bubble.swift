//
//  Bubble.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 26/4/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SpriteKit

enum BubbleColor {
    case red    // 40% spawn chance
    case pink   // 30%
    case green  // 15%
    case blue   // 10%
    case black  //  5%
}

class Bubble: SKShapeNode {
    private(set) var gamePoints: Int = 0
    var animPath: CGPath?
    
    init?(col: BubbleColor, pos: CGPoint, rad: CGFloat) {
        super.init()
        
        self.lineWidth = 0
        
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -rad, y:-rad), size: CGSize(width: 2*rad, height: 2*rad)), transform: nil)
        
        let pathRad: CGFloat = 0.25*rad
        
        self.animPath = CGPath(ellipseIn: CGRect(origin: CGPoint(x: pos.x-pathRad/2, y:pos.y-pathRad/2), size: CGSize(width: pathRad, height: pathRad)), transform: nil)
        
        switch col {
        case .red:
            self.fillColor = .systemRed
            self.gamePoints = 1
        case .pink:
            self.fillColor = .systemPink
            self.gamePoints = 2
        case .green:
            self.fillColor = .systemGreen
            self.gamePoints = 5
        case .blue:
            self.fillColor = .systemBlue
            self.gamePoints = 8
        case .black:
            self.fillColor = .black
            self.gamePoints = 10
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
