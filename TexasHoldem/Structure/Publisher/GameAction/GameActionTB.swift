//
//  TimeBankGA.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import Foundation
import GameKit


class GameActionTB: GameAction {
    
    override func defaultBankroll() {
        self.bankroll = 0
    }
    
    override func updateScores() {
        print("Update Score overrided")
        
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.setDefaultLeaderboardIdentifier("005_tbScore") { _ in
            print("Nuova leaderboard di Default")
        }
        
        GKLeaderboard.loadLeaderboards(IDs: ["005_tbScore"]) { leaderBoards, _ in
                    print("inside loadLeaderBoards")
            
            leaderBoards?[0].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in

                   guard error == nil else {return}
                   
                   if player?.score != nil {
                       
                       print("player score != nil")
                       let importedScore = player?.score
                       let floatScore = Float(importedScore!)
                       self.rebuyCount = floatScore / 100
                   }
               }
        }
    }
    
     override func resultAttribution(playerWin: Bool, combination: PossibleResults) {
        
      self.showAccessPoint(isActive: true)
        
      let timeConsumed = self.storedCountDown - self.countDown
         if timeConsumed <= 1.0 {achievementAccomplished(id: "006tb_fasterHand") } // Save Achievement faster hand
         
      let combinationPoint:Float
         
      self.handsTime.append(timeConsumed) // beta per testare il tempo di risposta e creare un achievement
         
        switch combination {
            
        case .straightFlush:
            combinationPoint = 40
            if playerWin {achievementAccomplished(id: "009tb_straightFlush") }   // saved achievement I get straight flush
        case .poker:
            combinationPoint = 15
        case .flush:
            combinationPoint = 20
        case .straight:
            combinationPoint = 20
        case .set:
            combinationPoint = 40
            if playerWin{achievementAccomplished(id: "010tb_setTheNut")}  // saved achievement Set the Nut
        }
        
        if playerWin {
            
            self.winSeries += 1
            if self.winSeries >= 15 {achievementAccomplished(id: "007tb_strike")} // saved achievement Amazing Strike
            
            let acceleratoreBySeries = 1 + (1 - (1 / self.winSeries))
            let scoreFirstStep = combinationPoint * (1 + (3/timeConsumed))
            
            self.moneyWinOrLoose = scoreFirstStep * acceleratoreBySeries // score finale
         
            self.maniVinte += 1
            
        
        } else {
            
            // salvare il winSeries prima dell'azzeramento
            saveWinSeries(idLeaderBoard: "007_winSeries")
            self.moneyWinOrLoose = 0
            self.winSeries = 0
            
        } // in caso di errore, non si perde nulla e la serie vincente viene azzerata
        
        self.hands += 1
        self.bankroll += self.moneyWinOrLoose
         if self.bankroll >= 1000 {achievementAccomplished(id: "008tb_scoreWall")} // saved achievement 1k Score Wall
        
    }
    
    override func resetForNewGame() {
        
        self.isGameEnded = false
        self.hands = 0
        self.maniVinte = 0
        self.bankroll = 0
        self.countDown = 60
        self.storedCountDown = 60
        self.winSeries = 0
        
    }
    
   override func compareScore() {
        
        if self.rebuyCount < self.bankroll {self.rebuyCount = self.bankroll}
        
    }
    
   override func saveScores() {
       
       print("saveScores Overrided")
       
        // TimeBank LeaderBoard Score == RebuyCount
        
        let extendedScore = self.rebuyCount * 100
        let intScore = Int(extendedScore)
        
        GKLeaderboard.submitScore(intScore, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["005_tbScore"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to ScoreTB:\(error.debugDescription.description)")
                return }
        }
       
       // Salviamo La miglior serie vincente
       saveWinSeries(idLeaderBoard: "007_winSeries")
    }
    
   
    
    
}
