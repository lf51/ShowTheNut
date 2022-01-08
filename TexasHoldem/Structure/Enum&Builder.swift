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

enum GameLevelTB:Float {
    
    case one = 60
    case two = 45
    case three = 30
    case four = 15
    
}

enum TimerSection:Float {
    
    case base = 0.01
    case booster_05 = 0.0005
    case booster_15 = 0.0015 // da sottrarre al base per il booster
    case booster_2 = 0.002
}

enum LeaderBoardsName:String {
    
    case generalScore_005TBnew
    case score60_001TB
    case score45_002TB
    case score30_003TB
    case score15_004TB
    
}

@resultBuilder
struct AchievementManager {
    
    static func buildBlock(_ components: String) {
        
        guard AuthPlayerGK.instance.localPlayerAuth else {
            print("localPlayer Non Autenticato. Achievement non salvato")
            return
        }
        
      //  let _:GKAchievement = {
            
            let achievement = GKAchievement(identifier: components)
        print("achiev:\(components) completed : \(achievement.isCompleted)")
        
            guard achievement.isCompleted == false else { // questo guard non funziona perchè il booleano isCompleted ritorna sempre false pure quando dovrebbe essere vero
                 print("achievement already done!")
              //  return achievement
                return 
            }
            
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            
            GKAchievement.report([achievement]) { error in
                        
                        guard error == nil else {return}
                        print("currentAchie \(components) salvato con successo")
                       // self.achievementsDone.append("red_001")
                    }
            
        //    return achievement
    //    }()

       /* GKAchievement.report([currentAchievement]) { error in
                    
                    guard error == nil else {return}
                    print("currentAchie \(components) salvato con successo")
                   // self.achievementsDone.append("red_001")
                } */
    }
}


