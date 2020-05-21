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

class Player : Identifiable {
    let id = UUID()
    
    let name: String
    var highScore: Int
    
    init(name: String, score: Int) {
        self.name = name
        self.highScore = score
    }
}

class Prefs: ObservableObject {
    // Player-based data
    private var allPlayerNames = [String]()
    @Published var allPlayers = [Player]()
    
    @Published var lastPlayerName: String {
        willSet {
            recordLatestPlayerStats(nickname: lastPlayerName)
        }
        
        didSet {
            loadPlayerStatByName(nickname: lastPlayerName)
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
    
    private let defaults = UserDefaults.standard
    
    init() {
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
            // I cannot use ResetVariables()
            // because it is init
            lastPlayerName = ""
            highestScore = 0
            gameplayTimeSlider = 60
            timer = 60
            bubbleNumberSlider = 15
        }
        lastScore = 0
        gameIsPaused = false
        gameIsOver = false
        
        allPlayerNames = Array(Set(defaults.array(forKey: "Players") as? [String] ?? [String]()))
        
        for index in 0..<allPlayerNames.count {
            let name = allPlayerNames[index]
            let score = defaults.integer(forKey: "\(name)_HS")
            allPlayers.append(Player(name: name, score: score))
        }
    }
    
    func updateAllPlayerNames(nickname: String) {
        var tmp = allPlayerNames
        tmp.append(nickname)
        tmp = Array(Set(tmp))
        
        if tmp.count > allPlayerNames.count {
            // 1
            allPlayerNames = tmp
            defaults.set(allPlayerNames, forKey: "Players")
            
            // 2
            let score: Int = defaults.integer(forKey: "\(nickname)_HS")
            allPlayers.append(Player(name: nickname, score: score))
        }
    }
    
    // Unfortunately, init doesn't take function ->
    // there is a code repeat
    func loadPlayerStatByName(nickname: String) {
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
            // this is the case when it is a new
            // player added after a game
            resetVariables()
        }
        updateAllPlayerNames(nickname: nickname)
    }
    
    func recordLatestPlayerStats(nickname: String) {
        // records latest preferences and scores to UserDefaults
        defaults.set(nickname, forKey: "PlayerName")
        defaults.set(self.highestScore, forKey: "\(nickname)_HS")
        defaults.set(self.gameplayTimeSlider, forKey: "\(nickname)_TS")
        defaults.set(self.bubbleNumberSlider, forKey: "\(nickname)_NS")
    }
    
    func updateHighScoreForPlayer(nickname: String, newHighScore: Int) {
        for player in allPlayers {
            if player.name == nickname {
                if player.highScore < newHighScore {
                    player.highScore = newHighScore
                    return
                }
            }
        }
    }
    
    func resetVariables() {
        highestScore = 0
        gameplayTimeSlider = 60
        timer = 60
        bubbleNumberSlider = 15
    }
    
    func clearRecords() {
        // remove Player data from current lists
        allPlayerNames.removeAll()
        allPlayers.removeAll()
        
        // clear all variables
        resetVariables()
        
        // remove Player data from UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // It removes all data recorded by User, but keep all main keys
        // required for the app:
        // print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
}
