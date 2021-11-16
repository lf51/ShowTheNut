//
//  GameAction.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 14/10/21.
//

import Foundation
import GameKit


class GameAction: ObservableObject {
    
    // Variabili il cui valore viene recuperato dal server GameKit
    
    @Published var bankroll: Float = 0.0
    @Published var hands: Float = 0.0 // le mani totali giocate
    @Published var maniVinte:Float = 0.0 // qui contiamo le mani vinte // il valore lo importiamo dalla leaderBoard, ricavandolo dal WinRate salvato. Questo perchè il win rate qui è una computed, la maniVintePercent, il che, per ovviare all'impostazione di un setter, ricalcoliamo andando ad estrapolare questo valore e ricombinandolo con le maniGiocate (Hands), anch'esso un valore salvato nella leaderBoard. Valutiamo l'impostazione del setter in maniVintePercent
    
    var rebuyCount:Float = 0.0
    @Published var localPlayerAuth:Bool = false
    
    // fine variabili il cui valore è recuperato dal server GameKit
    
    init() {
         
        authenticateUser()
    }

    @Published var pot:Float = 0.0
    @Published var bet: Float = 0.0
      
  //  var folds: Float {(maniPerseFoldate / hands) * 100} // tolta, vedi maniPerseFoldate
    var maniVintePercent: Float {(maniVinte / hands) * 100} // qui rendiamo in termini percentuali le mani vinte sulle mani totali
    
  // var maniPerseFoldate:Float = 0.0 // tolta perchè non serve. Basta cononoscere la percentuale di mani Vinte
    
    var gameOpen:Float = 0.0 // Apertura gioco
    var betLimitOnFlop: Float = 5.0 // sul flop 5x di Default rispetto al Game Open
    var betLimitOnTurn:Float = 3.0 // sul turn 3x di Default rispetto al GameOpen
    
    @Published var rebuyAvaible:Bool = false
   
    var moneyWinOrLoose: Float = 0.0 // vittoriaOrSconfitta
    var payOutAmplificator: Float = 3.0 // Di Default si vince 3x rispetto al Pot
    
    @Published var isTherePayOutReduction:Bool = false // mettiamo Published perchè cosi' mi si aggiorna in tempo reale
    
    var isPayOutAmplificatorLocked:Bool {
        
        self.bankroll == 0
        
    } // questo ci serve per bloccare il reset sul cButton in caso di All-In
    
    var payOutRate:Float {
        
        if self.isTherePayOutReduction {
            print("lazyVar payOutRate Frazionato")
            return (self.payOutAmplificator / 2.0) }
        else {
            print("lazyVar payOutRate Intero")
            return self.payOutAmplificator}
      
    }
    
    // LeaderBoard GameKit / BankRoll - Hands - Win Rate - Rebuy - Importiamo l'ultimo valore salvato nella leaderBoard.
    
    func authenticateUser() {
        
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { vc, error in
            
            guard error == nil else {
                self.bankroll = 200
                print("Player locale non autenticato - bankrool to 200.0")
                print(error?.localizedDescription ?? "")
                return
            }
            
           // vc è la view che appare qualora il player non sia autenticato e voglia autenticarsi o registrarsi nel game center
           // Superato il guard il local player è AUTENTICATO
           // self.bankroll = 200 // non mi piace messo qui // risolve il problema avuto con Gian che in partenza non gli dava credito, ma in nel caso un giocatore esce senza aver fatto il rebuy, al rientro da 0, poi 200, poi 0 e poi 200 nuovamente. Resta il dubbio sul perchè non funzionasse. Da trovare una soluzione.
            self.localPlayerAuth = true 
            self.showAccessPoint(isActive: true)
            self.updateScores(localPlayer: localPlayer) // carichiamo gli score dalla leaderBoard
            
         /*  let _: GKAccessPoint = {
                
                let dashBoard = GKAccessPoint.shared
               
               dashBoard.location = .topTrailing
               
               dashBoard.isActive = true
                
                
                return dashBoard
           
                
            }() */
            
         //   GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
            
            print("\(localPlayer.displayName) - isAuth: \(localPlayer.isAuthenticated.description)")
            
         //   if localPlayer.isAuthenticated {
           
                
                print("dentro if localPlayer.isAuth")
                
          //  }
        }
    }
 
    func showAccessPoint(isActive:Bool) {

        GKAccessPoint.shared.isActive = isActive // appare anche se il localPlayer non si è autenticato. Non crea comunque un conflitto ed è buono per ricordare al giocatore di potersi loggare dentro.
       
    }
    
    func updateScores(localPlayer:GKPlayer) {
   
        GKLeaderboard.loadLeaderboards(IDs: ["001_bankroll","004_winRate","002_hands","003_rebuy"]) { leaderBoards, _ in
            
            // load Bankroll
           // print("Leaderboard n°:\(leaderBoards?.count) - [0]: \(leaderBoards?[0].title)- [1]: \(leaderBoards?[1].title)- [2]: \(leaderBoards?[2].title)- [3]: \(leaderBoards?[3].title)")
    
            // load Hands // carichiamo prima perchè il valore delle mani giocate ci serve per estrapolare il numero di mani vinte dal win rate
            
            leaderBoards?[2].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
                   
                //   print("importedScore: \(player?.score)")
                   guard error == nil else {return}
                   
                   if player?.score != nil {
                       
                       let importedScore = player?.score
                       self.hands = Float(importedScore!)

                       //   print("ComplitionHandler_02")
                   
                   }
               }
            
            // load Rebuy
            
            leaderBoards?[3].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
                
             //   print("importedScore: \(player?.score)")
                guard error == nil else {return}
                
                if player?.score != nil {
                    
                    let importedScore = player?.score
                    self.rebuyCount = Float(importedScore!)
              
                 //   print("ComplitionHandler_02")
                
                }
            }

            // load Win Rate / bankroll // gli diamo uno stacco con il Dispatch perchè altrimenti si accavallano e non fa in tempo ad aggiornare le hands e i rebuy.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
            leaderBoards?[0].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
                    
                 //   print("importedScore: \(player?.score)")
                    guard error == nil else {
                        
                        self.bankroll = 200
                        print("Probabile prima autenticazione")
                        return
                        
                    }
                    
                    if player?.score != nil {
                        
                        let importedScore = player?.score
                        let floatScore = Float(importedScore!)
                     //   print("Float score: \(floatScore)")
                        let ultimateScore = floatScore / 100
                        
                        self.bankroll = (ultimateScore + 200) + (self.rebuyCount * 200)
                        
                        if self.bankroll == 0 {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.bankroll = 200
                                self.rebuyCount += 1
                                self.saveScores()
                            }
                        }
                      //  print("player?.score != nil e equal to")
                    
                    } // else {self.bankroll = 200 }
                }
                
                leaderBoards?[1].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
         
                     guard error == nil else {return}
                     
                     if player?.score != nil {
                         
                         let importedScore = player?.score
                         let floatScore = Float(importedScore!)
                      //   print("Float score: \(floatScore)")
                         let ultimateScore = floatScore / 10000
                         print("mani totali dentro complationHandler [1]:\(self.hands)")
                         self.maniVinte = self.hands * ultimateScore
                         
                      //   print("ComplitionHandler_02")
                     
                     }
                 }
            }

        }
    }
    
    func saveScores() {
        
        // LeaderBoard Bankroll
        let netBankroll = (self.bankroll - 200) - (200 * self.rebuyCount) // sottraiamo al bankroll la posta iniziale e poi 200 per ogni rebuy
        
        let extendedBankroll = netBankroll * 100 // spostiamo la virgola di due posizioni
        let intBankroll = Int(extendedBankroll)  // trasformiamo in intero di modo da eliminare la virgola. Quando sarà attribuito alla classifica, in questa verranno messe due posizioni decimali (dal GameKit) e il numero sarà così uguale all'originale
        
        GKLeaderboard.submitScore(intBankroll, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["001_bankroll"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to Bankroll:\(error.debugDescription.description)")
                return }
        }

        // LeaderBoard Win Rate
        
            let extendedWinRate = self.maniVintePercent * 100
            let intWinRate = Int(extendedWinRate)

        GKLeaderboard.submitScore(intWinRate, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["004_winRate"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to WinRate:\(error.debugDescription.description)")
                return }
        }
        
        // LeaderBoard Hands
        
       // let extendedHands = self.hands * 100
        let intHands = Int(self.hands)
        
        GKLeaderboard.submitScore(intHands, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["002_hands"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to Hands:\(error.debugDescription.description)")
                return }
        }
  
        // LeaderBoard Rebuy
        
       // let extendedRebuy = self.rebuyCount * 100
        let intRebuy = Int(self.rebuyCount)
        
        GKLeaderboard.submitScore(intRebuy, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["003_rebuy"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to ReBuy:\(error.debugDescription.description)")
                return }
        }
      
    }
    
  // end Configurazione LeaderBoard GameKit / BankRoll - Hands - Win Rate - Rebuy
    
    // Configurazione Achievement
    
    func loadAchievements() {
        
        GKAchievement.loadAchievements { achievements, error in
            
            guard error == nil else {return}
            
            print("AchievementCount:\(achievements?.count ?? 0)")
            
            
        }
     
    }
    

    
    
    
    
    // end configurazione Achievement
    
    
    
    func betButton(bet:String,stepCount:Int) {
        
        guard let valueBet = Float(bet) else {return}
        
        guard (self.bankroll - self.bet) - valueBet >= 0 else {return }
        
        if stepCount == 2 {
            
            self.bet += valueBet // OpenBet
        }
        
        else if stepCount == 4 {
            
            guard (self.bet + valueBet) <= (gameOpen * betLimitOnFlop) else {return}
            
            self.bet += valueBet
        }
        
        else if stepCount == 6 || stepCount == 7 {
            
            guard (self.bet + valueBet) <= (gameOpen * betLimitOnTurn) else {return}
            
            self.bet += valueBet
        }
        //stepCount 4 sul Flop
        
        //stepCount 6 sul turn
        
        //stepCount 7 sul turnAfterPick
     
    }
    
    func cButton() {
        
        self.bet = 0.0
        
        if !isPayOutAmplificatorLocked{self.payOutAmplificator = 3.0}
         // questo serve per resettare ed evitare che uno facendo all-in e poi cancellando, resti con il x6
        
    }
    
    func allInButton(stepCount:Int){
        
        if stepCount == 2 {
            self.bet = self.bankroll
            self.payOutAmplificator *= 2.0 // l'All in PreFlop paga 2x il default
        
        } // Come Open Bet è un ALL IN
        
        else if stepCount == 4 {
            
            if (gameOpen * betLimitOnFlop) > self.bankroll {self.bet = self.bankroll } else {self.bet = (gameOpen * betLimitOnFlop)} // sul flop viene limitato
     
        }
        
        else if stepCount == 6 || stepCount == 7 {
            
            if (gameOpen * betLimitOnTurn) > self.bankroll {self.bet = self.bankroll } else {self.bet = (gameOpen * betLimitOnTurn)} // sul turn viene limitato
            
            
        }
        
    }
    
    func potComposition(stepCount:Int) {
    
        self.pot += self.bet
        self.bankroll -= self.bet

        if stepCount == 2 {
            
            self.gameOpen = self.bet
          //  if self.bankroll == 0 {self.isPayOutAmplificatorLocked = true}
            
        } // impostiamo l'apertura
        self.bet = 0.0
        
    }
    
    func cleanOrFoldAction() {
        
        self.hands += 1
        saveScores()
        self.pot = 0.0
        self.bet = 0.0
        
      //  self.maniPerseFoldate += 1
       
        
    }
    
    func resultAttribution(playerWin:Bool) {
        
        self.showAccessPoint(isActive: true)
        
        if playerWin {
            
            self.moneyWinOrLoose = (self.pot * self.payOutRate)
            
            self.bankroll += self.moneyWinOrLoose
            
            self.maniVinte += 1
            
        } else {
            
            self.moneyWinOrLoose = self.pot
      
         //   self.maniPerseFoldate += 1
            
        }
        
        self.hands += 1
        saveScores()
        self.pot = 0.0
        self.bet = 0.0
        self.isTherePayOutReduction = false
        self.payOutAmplificator = 3.0
        
        
    }
    
    func reBuy() {
        
        self.rebuyAvaible = true
        self.rebuyCount += 1.0
        
        self.showAccessPoint(isActive: false)
    }
    
}
