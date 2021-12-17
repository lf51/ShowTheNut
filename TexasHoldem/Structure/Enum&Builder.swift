//
//  Enum.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 12/10/21.
//

import Foundation
import GameKit

enum PossibleResults {
 
    case straightFlush
    case poker(quadsOnBoardKickerPlay:Bool)
    case flush(seedCount:Int) // associamo un valore Int che sarà il numero di carte dello stesso seme sul board. Utile per calcolare il result
    case straight
    case set
}

enum InSecondTB:Float {
    
    case level_1 = 60
    case level_2 = 45
    case level_3 = 30
    case level_4 = 15
    
}

@resultBuilder
struct AchievementManager {
    
    static func buildBlock(_ components: String) {
        
        let currentAchievement:GKAchievement = {
            
            let achievement = GKAchievement(identifier: components)
            
            guard !achievement.isCompleted else {
                 print("achievement already done!")
                return achievement
            }
            
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            
            return achievement
        }()

        GKAchievement.report([currentAchievement]) { error in
                    
                    guard error == nil else {return}
                    print("currentAchie \(components) salvato con successo")
                   // self.achievementsDone.append("red_001")
                }
    }
}


