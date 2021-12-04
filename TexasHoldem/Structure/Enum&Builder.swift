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

/*enum ChipsValue: Float {
    
    case ten = 100
    case five = 5
    case one = 1
    case c
    case all
    case fiftyCent = 0.50
        
}*/

enum ChipsValue{
    
    case high(value:String)
    case middle(value:String)
    case big(value:String)
    case small(value:String)
    case c
    case all
    
}

enum TableLevel:String {
    
    case green = "50c - 1"
    case red = "2 - 5"
    case blue = "5 - 10"
    case gold = "15 - 30"
    case black = "50 - 100"
    case iceBlack = "250 - 500"

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


