//
//  HighScore.swift
//  polypew
//
//  Created by Andrew Yang on 12/12/18.
//  Copyright © 2018 Andrew Yang. All rights reserved.
//

import Foundation

class HighScore: Codable {
    var score: Int
    
    init() {
        self.score = 0
    }
    
    init(score: Int) {
        self.score = score
    }
    
    static let scoresPListURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("highScores").appendingPathExtension(".plist")
        return fileURL
    }()
    
    static func saveToFile(scores: [HighScore]) {
        let pListEncoder = PropertyListEncoder()
        if let scoresData = try? pListEncoder.encode(scores) {
            try? scoresData.write(to: scoresPListURL)
        }
    }
    
    static func loadFromFile() -> [HighScore]? {
        let pListDecoder = PropertyListDecoder()
        
        if let scoresData = try? Data (contentsOf: scoresPListURL), let decodedScores = try? pListDecoder.decode([HighScore].self, from: scoresData) {
            return decodedScores
        }
        return nil
    }
}
