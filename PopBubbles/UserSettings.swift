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

struct PlayerSettings {
    public var lastPlayerName: String
    public var highestScore: Int
    public var lastTimer: Int
    
    public var lastScore: Int
    
    init() {
        let defaults = UserDefaults.standard
        
        if UserDefaults.exists(key: "PlayerName") {
            self.lastPlayerName = defaults.string(forKey: "PlayerName")!
            self.highestScore = defaults.integer(forKey: "\(self.lastPlayerName)_HS")
            self.lastTimer = defaults.integer(forKey: "\(self.lastPlayerName)_LT")
        } else {
            lastPlayerName = ""
            highestScore = 0
            lastTimer = 0
        }
        
        lastScore = 0
    }
}

struct GameSettings {
    var gameplayTimeSlider: Double = 0
    var bubbleNumberSlider: Double = 0
    
    init(playerName: String) {
        let defaults = UserDefaults.standard
        self.gameplayTimeSlider = defaults.double(forKey: "\(playerName)_LT")
        self.bubbleNumberSlider = defaults.double(forKey: "\(playerName)_BN")
        
    }
}

class Prefs: ObservableObject {
    @Published var lastPlayer = PlayerSettings.self
    @Published var gameSettings = GameSettings.self
}

class UserSettings: ObservableObject {
    @Published var playerScore: Int = 0
}
