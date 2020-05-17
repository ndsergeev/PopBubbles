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

struct Player : Identifiable {
  let id: Int

  let name: String
  var highScore: Int
}

class Prefs: ObservableObject {
    // Player-based data
    @Published var allPlayers = [Player]()
    
    @Published var lastPlayerName: String {
        willSet {
            UpdatePlayer(nickname: lastPlayerName)
        }
        
        didSet {
            LoadPlayer(nickname: lastPlayerName)
        }
    }
    @Published var highestScore: Int
    @Published var gameplayTimeSlider: TimeInterval
    @Published var bubbleNumberSlider: Double
    
    // Game-based data
    @Published var timer: TimeInterval
    @Published var gameIsPaused: Bool
    @Published var gameIsOver: Bool
    @Published var lastScore: Int
    
    init() {
        let defaults = UserDefaults.standard
        
        if UserDefaults.exists(key: "PlayerName") {
            let _lastPlayerName = defaults.string(forKey: "PlayerName")!
            lastPlayerName = _lastPlayerName
            
            if UserDefaults.exists(key: "\(_lastPlayerName)_HS") {
                let _highestScore = defaults.integer(forKey: "\(_lastPlayerName)_HS")
                highestScore = _highestScore
            } else {
                highestScore = 0
            }
            
            if UserDefaults.exists(key: "\(_lastPlayerName)_TS") {
                let _gameplayTimeSlider = defaults.double(forKey: "\(_lastPlayerName)_TS")
                gameplayTimeSlider = _gameplayTimeSlider
                timer = _gameplayTimeSlider
            } else {
                gameplayTimeSlider = 60
                timer = 60
            }
            
            if UserDefaults.exists(key: "\(_lastPlayerName)_NS") {
                let _bubbleNumberSlider = defaults.double(forKey: "\(_lastPlayerName)_NS")
                bubbleNumberSlider = _bubbleNumberSlider
            } else {
                bubbleNumberSlider = 15
            }
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
    
    // Unfortunately, init doesn't take function ->
    // there is a code repeat
    func LoadPlayer(nickname: String) {
        let defaults = UserDefaults.standard
        
        if UserDefaults.exists(key: "PlayerName") {
            if UserDefaults.exists(key: "\(nickname)_HS") {
                let _highestScore = defaults.integer(forKey: "\(nickname)_HS")
                highestScore = _highestScore
            } else {
                highestScore = 0
            }
            
            if UserDefaults.exists(key: "\(nickname)_TS") {
                let _gameplayTimeSlider = defaults.double(forKey: "\(nickname)_TS")
                gameplayTimeSlider = _gameplayTimeSlider
                timer = _gameplayTimeSlider
            } else {
                gameplayTimeSlider = 60
                timer = 60
            }
            
            if UserDefaults.exists(key: "\(nickname)_NS") {
                let _bubbleNumberSlider = defaults.double(forKey: "\(nickname)_NS")
                bubbleNumberSlider = _bubbleNumberSlider
            } else {
                bubbleNumberSlider = 15
            }
        } else {
            highestScore = 0
            gameplayTimeSlider = 60
            timer = 60
            bubbleNumberSlider = 15
        }
    }
    
    func UpdatePlayer(nickname: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(nickname, forKey: "PlayerName")
        defaults.set(self.highestScore, forKey: "\(nickname)_HS")
        defaults.set(self.gameplayTimeSlider, forKey: "\(nickname)_TS")
        defaults.set(self.bubbleNumberSlider, forKey: "\(nickname)_NS")
    }

    func UpdateName() {
        UserDefaults.standard.set(self.lastPlayerName, forKey: "PlayerName")
    }
    
    func UpdateHighScore() {
        UserDefaults.standard.set(self.highestScore, forKey: "\(self.lastPlayerName)_HS")
    }
    
    func UpdateTimeSlider() {
        UserDefaults.standard.set(self.gameplayTimeSlider, forKey: "\(self.lastPlayerName)_TS")
    }
    
    func UpdateNumberSlider() {
        UserDefaults.standard.set(self.bubbleNumberSlider, forKey: "\(self.lastPlayerName)_NS")
    }
    
    func ClearRecords() {
        UserDefaults.resetStandardUserDefaults()
    }
}
