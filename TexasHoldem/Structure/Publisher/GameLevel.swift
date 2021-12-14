//
//  GameLevel.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 05/11/21.
//

import Foundation
import SwiftUI
import GameKit

// inserire il livello platinum o corallo da 20k al posto del black. Black diventa da 100k


/*class GameLevel: ObservableObject {
    
    @Published var level: TableLevel = .green
    
    @Published var smallBlindValue:String = "0.50"
    @Published var bigBlindValue:String = "1"
    @Published var middleValue:String = "5"
    @Published var highValue:String = "10"
    
    @Published var tableColor:CGColor = CGColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
    
    var tableLevel:[TableLevel] = [.green]  // di default è al livello Green, poi viene riempito in base al bankroll, aggiungendo di volta in volta il livello in posizione [0]

    @Published var temporaryLockTransitionLevel:Bool = false
    
    var lockArrow:(leftA:Bool,rightA:Bool) {
        
        if tableLevel.count == 1 {return (true,true)}
        
        else {
            let index = tableLevel.firstIndex(of: level)
            if index == 0 {return (false,true)}
            else if index == (tableLevel.count - 1) {return (true,false)}
            else {return (false,false)}
        }
    }
    
    @Published var achievementsDone:[String] = [] //contiene gli achievement raggiunti // se il player non è autenticato resta vuoto e non viene compilato.
    
    func loadAchievementDone() {
            
      /* GKAchievement.resetAchievements { error in
            guard error == nil else { return}
            print("achievement resettati")
        } */
        
            GKAchievement.loadAchievements { achievements, error in
                
                guard error == nil else {return}

                self.achievementsDone = achievements?.map({ achievement in
                    achievement.identifier
                }) ?? []

                print("elenco achievement caricato con successo")
                print("achiCount\(self.achievementsDone.count)")
            }
    }
    
   /* func unlockLevel(bankroll:Float,sitHighestTable:Bool,playerAuth:Bool) {
                 
        let tablesAvaibleAtBeginning:Int = self.tableLevel.count
        self.tableLevel = [.green] // ad ogni chiamata l'array viene svuotato e poi riempito nuovamente
        let money = bankroll
        
        if money >= 1000 {
                
                self.tableLevel.insert(.red, at: 0)
     
        if playerAuth && !achievementsDone.contains("red_001") {
                    
            let redTableAchievement:GKAchievement = {
                
                let achievement = GKAchievement(identifier: "red_001")
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
                
                return achievement
            }()
                    GKAchievement.report([redTableAchievement]) { error in
                        
                        guard error == nil else {return}
                        print("redTable salvato con successo")
                        self.achievementsDone.append("red_001")
                    }
                }
        }
        
        if money >= 2000 {
                
                self.tableLevel.insert(.blue, at: 0)
     
        if playerAuth && !achievementsDone.contains("blue_002") {
                    
            let blueTableAchievement:GKAchievement = {
                
                let achievement = GKAchievement(identifier: "blue_002")
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
                
                return achievement
            }()
                    GKAchievement.report([blueTableAchievement]) { error in
                        
                        guard error == nil else {return}
                        print("blueTable salvato con successo")
                        self.achievementsDone.append("blue_002")
                    }
                }
        }
        
        if money >= 6000 {
                
                self.tableLevel.insert(.gold, at: 0)
     
        if playerAuth && !achievementsDone.contains("gold_003") {
            
            let goldTableAchievement:GKAchievement = {
                
                let achievement = GKAchievement(identifier: "gold_003")
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
                
                return achievement
            }()
                    GKAchievement.report([goldTableAchievement]) { error in
                        
                        guard error == nil else {return}
                        print("goldTable salvato con successo")
                        self.achievementsDone.append("gold_003")
                    }
                }
        }
        
        if money >= 20000 {
                
                self.tableLevel.insert(.black, at: 0)
     
        if playerAuth && !achievementsDone.contains("black_004") {

            let blackTableAchievement:GKAchievement = {
                
                let achievement = GKAchievement(identifier: "black_004")
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
                
                return achievement
            }()

                GKAchievement.report([blackTableAchievement]) { error in
                        
                        guard error == nil else {return}
                        print("blackTable salvato con successo")
                    self.achievementsDone.append("black_004")
                    }
                }
        }
        
        if money >= 100000 {
                
            self.tableLevel.insert(.iceBlack, at: 0)
     
        if playerAuth && !achievementsDone.contains("coral_005") { // vecchio id identificativo

            let iceBlackTableAchievement:GKAchievement = {
                
                let achievement = GKAchievement(identifier: "coral_005")
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
                
                return achievement
            }()

                GKAchievement.report([iceBlackTableAchievement]) { error in
                        
                        guard error == nil else {return}
                        print("iceBlackTable salvato con successo")
                    self.achievementsDone.append("coral_005")
                    }
                }
        }
      
        if sitHighestTable {
            self.level = self.tableLevel[0]
            self.colorTable()
        } // lavora solo all'apertura del gioco. Viene impostato su true in stepCount == 0. I seguenti lavorano su stepcount == 9.
        
     //  else if tableAvaible == self.tableLevel.count {}// resta il tavolo preselezionato}
        
        else if tablesAvaibleAtBeginning < self.tableLevel.count {
            self.level = self.tableLevel[0]
            self.colorTable()
        } //vuol dire che c'è stato un avanzamento
        
        else if tablesAvaibleAtBeginning > self.tableLevel.count {
           
           if !tableLevel.contains(level) {
               self.level = self.tableLevel[0]
               self.colorTable()
           } // c'è stato un arretramento, il tavolo viene cambiato solo se il giocatore stava giocando al tavolo non più disponibile.
       }
        
       // self.colorTable()
        print("unlock Level called")
    } */ // old Version sostituita per usare un function Builder
    
    @AchievementManager
    func achievementAccomplished(id:String) {id}
    
    func unlockLevel(bankroll:Float,sitHighestTable:Bool,playerAuth:Bool) {
                  
         let tablesAvaibleAtBeginning:Int = self.tableLevel.count
         self.tableLevel = [.green] // ad ogni chiamata l'array viene svuotato e poi riempito nuovamente
         let money = bankroll
         
         if money >= 1000 {
                 
                 self.tableLevel.insert(.red, at: 0)
      
         if playerAuth && !achievementsDone.contains("red_001") {
                     
            achievementAccomplished(id: "red_001")
             
                 }
         }
         
         if money >= 2000 {
                 
                 self.tableLevel.insert(.blue, at: 0)
      
         if playerAuth && !achievementsDone.contains("blue_002") {
                     
             achievementAccomplished(id: "blue_002")
             
                 }
         }
         
         if money >= 6000 {
                 
                 self.tableLevel.insert(.gold, at: 0)
      
         if playerAuth && !achievementsDone.contains("gold_003") {
             
            achievementAccomplished(id: "gold_003")
             
                 }
         }
         
         if money >= 20000 {
                 
                 self.tableLevel.insert(.black, at: 0)
      
         if playerAuth && !achievementsDone.contains("black_004") {

           achievementAccomplished(id: "black_004")
             
                 }
         }
         
         if money >= 100000 {
                 
             self.tableLevel.insert(.iceBlack, at: 0)
      
         if playerAuth && !achievementsDone.contains("coral_005") { // vecchio id identificativo

            achievementAccomplished(id: "coral_005")
             
                 }
         }
       
         if sitHighestTable {
             self.level = self.tableLevel[0]
             self.colorTable()
         } // lavora solo all'apertura del gioco. Viene impostato su true in stepCount == 0. I seguenti lavorano su stepcount == 9.
         
      //  else if tableAvaible == self.tableLevel.count {}// resta il tavolo preselezionato}
         
         else if tablesAvaibleAtBeginning < self.tableLevel.count {
             self.level = self.tableLevel[0]
             self.colorTable()
         } //vuol dire che c'è stato un avanzamento
         
         else if tablesAvaibleAtBeginning > self.tableLevel.count {
            
            if !tableLevel.contains(level) {
                self.level = self.tableLevel[0]
                self.colorTable()
            } // c'è stato un arretramento, il tavolo viene cambiato solo se il giocatore stava giocando al tavolo non più disponibile.
        }
         
        // self.colorTable()
         print("unlock Level called")
     }
    
    
    
    func moveLevel(forward:Bool) {
        
        // ragiona al contrario poichè abbiamo fatto una modifica e nella ghera li abbiamo dovuti invertire. Il forward in realtà torna indietro, poichè nell'array il valore più alto si trova in posizione [0]
        
        if forward {
            
            var levelIndex = self.tableLevel.firstIndex(of: self.level)
            
            if levelIndex ?? 0 < (self.tableLevel.count - 1 ) {
                
                levelIndex! += 1
                self.level = tableLevel[levelIndex ?? 0]
                
            }
    
        } else {
            
            var levelIndex = self.tableLevel.firstIndex(of: self.level)
            
            if levelIndex ?? 0 > 0 {
                
                levelIndex! -= 1
                self.level = tableLevel[levelIndex ?? 0]
                
            }
            
        }
        
        colorTable()
    }
    
    func colorTable() {

        switch self.level {
            
        case .green:
            self.tableColor = CGColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            self.smallBlindValue = "0.50"
            self.bigBlindValue = "1"
            self.middleValue = "5"
            self.highValue = "10"
            
        case .red:
            self.tableColor = CGColor(red: 0.45, green: 0, blue: 0, alpha: 1)
            self.smallBlindValue = "2"
            self.bigBlindValue = "5"
            self.middleValue = "25"
            self.highValue = "50"
            
        case .blue:
            self.tableColor = CGColor(red: 0, green: 0.1, blue: 0.6, alpha: 1)
            self.smallBlindValue = "5"
            self.bigBlindValue = "10"
            self.middleValue = "50"
            self.highValue = "100"
            
        case .gold:
            self.tableColor = CGColor(red: 0.6, green: 0.5, blue: 0, alpha: 1)
            self.smallBlindValue = "15"
            self.bigBlindValue = "30"
            self.middleValue = "150"
            self.highValue = "300"
            
        case .black:
            self.tableColor = CGColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)
            self.smallBlindValue = "50"
            self.bigBlindValue = "100"
            self.middleValue = "500"
            self.highValue = "1000"
     
        case .iceBlack:
            self.tableColor = CGColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)
            self.smallBlindValue = "250"
            self.bigBlindValue = "500"
            self.middleValue = "2500"
            self.highValue = "5000"
         
        }

    }
}*/
