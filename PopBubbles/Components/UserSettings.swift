//
//  UserSettings.swift
//  PopBubbles
//
//  Created by Nikita Sergeev on 2/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

class Prefs: ObservableObject {
    @Published var lastPlayerName: String
    @Published var highestScore: Int
    
    @Published var lastScore: Int
    
    @Published var gameplayTimeSlider: Double
    @Published var bubbleNumberSlider: TimeInterval
    @Published var timer: TimeInterval
    
    @Published var gameIsPaused: Bool
    @Published var gameIsOver: Bool
    
    init() {
        let defaults = UserDefaults.standard
        
        if UserDefaults.exists(key: "PlayerName") {
            let _lastPlayerName = defaults.string(forKey: "PlayerName")!
            let _highestScore = defaults.integer(forKey: "\(_lastPlayerName)_HS")
            let _gameplayTimeSlider = defaults.double(forKey: "\(_lastPlayerName)_LT")
            let _bubbleNumberSlider = defaults.double(forKey: "\(_lastPlayerName)_BN")
            
            self.lastPlayerName = _lastPlayerName
            self.highestScore = _highestScore
            self.gameplayTimeSlider = _gameplayTimeSlider
            self.bubbleNumberSlider = _bubbleNumberSlider
            self.timer = _bubbleNumberSlider
        } else {
            lastPlayerName = ""
            highestScore = 0
            gameplayTimeSlider = 60
            timer = 60
            bubbleNumberSlider = 15
        }
        
        lastScore = 0
        gameIsPaused = false
        gameIsOver = false
    }
}
