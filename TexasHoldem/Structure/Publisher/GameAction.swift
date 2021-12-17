//
//  GameAction.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 14/10/21.
//

import Foundation
import GameKit
import SwiftUI


class GameAction: ObservableObject {
    
   let timer = Timer.publish(every: 0.01, tolerance: .none, on: .main, in: .common, options: .none).autoconnect()
    
    @Published var countDown:Float // secondi
    var storedCountDown:Float // è il valore del countdown al tempo t-1
    var winSeries:Float = 0 // è il numero di vittorie consecutive // usata in both the game per gli achievement
    var isGameEnded:Bool = false
    
    var handsTime:[Float] = [] // beta per vedere nel test la media delle risposte per creare un achievement
  //  var isDealButtonActive:Bool = false
     
    
    var inSecond:InSecondTB
    var colorTable:Color = Color(red: 0, green: 0.5603182912, blue: 0)
    
    func defaultBankroll() {self.bankroll = 0}
    
 
    
    //
    
    // Variabili il cui valore viene recuperato dal server GameKit
    
    @Published var bankroll: Float = 0.0
    @Published var hands: Float = 0.0 // le mani totali giocate
    @Published var maniVinte:Float = 0.0 // qui contiamo le mani vinte // il valore lo importiamo dalla leaderBoard, ricavandolo dal WinRate salvato. Questo perchè il win rate qui è una computed, la maniVintePercent, il che, per ovviare all'impostazione di un setter, ricalcoliamo andando ad estrapolare questo valore e ricombinandolo con le maniGiocate (Hands), anch'esso un valore salvato nella leaderBoard. Valutiamo l'impostazione del setter in maniVintePercent
    
    @Published var rebuyCount:Float = 0.0 // Nel gioco classico stocca il numero di rebuy, nel gioco a tempo stocca il miglior Punteggio
    
    // STATIC
    static var roundTBcount:Int = 0 // conta i round di gioco TB
    static var isTBPremium:Bool = false 
    static var localPlayerAuth:Bool = false
    static var authFailed:Bool = false // qualora l'autenticazione fallisce, nei secondi ingressi l'autanticationHandler non parte e allora usiamo questo bool per ricaricare i valori.
    
    // fine variabili il cui valore è recuperato dal server GameKit
    
    init(inSecond:InSecondTB) {
        
        print("init in SuperClasse GameAction inSecond:\(inSecond) e authFailed: \(GameAction.authFailed) e localPlayerAuth: \(GameAction.localPlayerAuth)")
        
        self.inSecond = inSecond
        self.countDown = inSecond.rawValue
        self.storedCountDown = inSecond.rawValue
        self.tableColor()
        
        if GameAction.localPlayerAuth {
            print("Probabile secondo ingresso con Player già autenticato")
            self.ifLocalPlayerIsAuth()}
        
        else if GameAction.authFailed {
            print("Probabile secondo ingresso con autenticazione precedentemente FALLITA. Verifica: is PlayerAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
            self.defaultBankroll()}
        
        else {
            print("Probabile PRIMO ACCESSO")
            self.authenticateUser() }
        
    }
    
    
    func tableColor() {
        print("insideTableColor()")
        switch inSecond {
            
        case .level_1:
            return self.colorTable = Color(red: 0, green: 0.5603182912, blue: 0)
        case .level_2:
            return self.colorTable = Color(red: 0.45, green: 0, blue: 0)
        case .level_3:
            return self.colorTable = Color(red: 0, green: 0.1, blue: 0.6)
        case .level_4:
            return self.colorTable = Color(red: 0.07, green: 0.07, blue: 0.07)
        }
        
    }
    
    
    
   /* deinit {
        print("in deinit is LocalPlayerAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
        print("deinit GameAction SuperClass")
        saveOnFirebase()
        
    }*/

  //  @Published var pot:Float = 0.0
  //  @Published var bet: Float = 0.0
      
  //  var folds: Float {(maniPerseFoldate / hands) * 100} // tolta, vedi maniPerseFoldate
    var maniVintePercent: Float {
        let firstStep = ((maniVinte / hands) * 10000).rounded() //prendiamo le prime 4 cifre dopo lo zero e creiamo un intero arrotondato
        return firstStep / 100
        
        
    } // qui rendiamo in termini percentuali le mani vinte sulle mani totali
    
  // var maniPerseFoldate:Float = 0.0 // tolta perchè non serve. Basta cononoscere la percentuale di mani Vinte
    
   // var gameOpen:Float = 0.0 // Apertura gioco
   // var betLimitOnFlop: Float = 5.0 // sul flop 5x di Default rispetto al Game Open
  //  var betLimitOnTurn:Float = 2.0 // sul turn 2x di Default rispetto al GameOpen
    
  //  @Published var rebuyAvaible:Bool = false
   
    var moneyWinOrLoose: Float = 0.0 // vittoriaOrSconfitta
  //  @Published var payOutAmplificator: Float = 2.0 // Di Default si vince 3x rispetto al Pot
    
  //  @Published var isTherePayOutReduction:Bool = false // mettiamo Published perchè cosi' mi si aggiorna in tempo reale
    
    var isPlayerInAllIn:Bool {
        
        self.bankroll == 0
        
    } // questo ci serve per bloccare il reset sul cButton in caso di All-In
    
 //   @Published var isBetLocked:Bool = false
  /*  var payOutRate:Float {
        
        if self.isTherePayOutReduction {
            print("lazyVar payOutRate Frazionato")
            return (self.payOutAmplificator / 2.0) }
        else {
            print("lazyVar payOutRate Intero")
            return self.payOutAmplificator}
      
    } */
    
    // LeaderBoard GameKit / BankRoll - Hands - Win Rate - Rebuy - Importiamo l'ultimo valore salvato nella leaderBoard.
    
    @Published var isLoading:Bool = false // ci serve a gestire le attese iniziali di autenticazione
    
    func authenticateUser() {

        print("localPlayer isAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
        self.isLoading = true 
        
        GKLocalPlayer.local.authenticateHandler = {vc, error in
             
             print("INSIDE AUTHENTICATEHANDLER")
             
             guard error == nil else {
                
                 self.defaultBankroll()
                 GameAction.authFailed = true
                 print("Error != nil -> is Player locale autenticato: \(GKLocalPlayer.local.isAuthenticated.description) - bankroll to \(self.bankroll) ")
                 self.isLoading = false 
                 print(error?.localizedDescription ?? "")
                 return
             }
            
            GameAction.localPlayerAuth = true
            self.ifLocalPlayerIsAuth()
            self.isLoading = false
            print("\(GKLocalPlayer.local.displayName) - isAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
            print("dentro if localPlayer.isAuth")
         }
     }
    
    func ifLocalPlayerIsAuth() {
        
        print("inside method ifLocalPlayerIsAuth")
       
        self.showAccessPoint(isActive: true)
        self.updateScores()
        
    }
    
   func resetForNewGame() {
        
        self.isGameEnded = false
        self.hands = 0
        self.maniVinte = 0
        self.bankroll = 0
        self.countDown = self.inSecond.rawValue
        self.storedCountDown = self.inSecond.rawValue
        self.winSeries = 0
        
    }
    
    func compareScore() {
         
         if self.rebuyCount < self.bankroll {self.rebuyCount = self.bankroll}
         
     }
   /* func authenticateUser() {
        print("auth in GameAction")
        let localPlayer = GKLocalPlayer.local
        print("localPlayer isAuth: \(localPlayer.isAuthenticated.description)")
        
        localPlayer.authenticateHandler = { vc, error in
            
            guard error == nil else {
               
                self.defaultBankroll()
            
                print("Error != nil -> is Player locale autenticato: \(localPlayer.isAuthenticated.description) - bankroll to \(self.bankroll) ")
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
    } */
 
    func showAccessPoint(isActive:Bool) {

        guard GameAction.localPlayerAuth else { return }
        
        GKAccessPoint.shared.isActive = isActive // appare anche se il localPlayer non si è autenticato. Non crea comunque un conflitto ed è buono per ricordare al giocatore di potersi loggare dentro.
        
    }

     func updateScores() {
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
                       self.rebuyCount = floatScore / 100 // nel rebuyCount salviamo il BestScore
                   }
               }
        }
    }
    
   func saveScores() {
        
        guard GameAction.localPlayerAuth else {
            
            print("In TB giocatore non loggato - Nessun Salvataggio su GameKit")
            saveForPremiumCheck()
            return
        }
        saveScoresOnGameKit()
        saveForPremiumCheck()
        print("saveScores Overrided completamente")
     }
    
   func saveScoresOnGameKit() {
        
        print("saveScoresOnGameKit Overrided")
        
         // TimeBank LeaderBoard Score == RebuyCount
         
         let extendedScore = self.rebuyCount * 100
         let intScore = Int(extendedScore)
         
         GKLeaderboard.submitScore(intScore, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["005_tbScore"]) { error in
             
             guard error == nil else {
                 print("Error in submitScore to ScoreTB:\(error.debugDescription.description)")
                 return }
         }
        
        saveWinSeries(idLeaderBoard: "007_winSeries")

     }
    
    func saveForPremiumCheck() {
        
            let userDefault = UserDefaults.standard
            
            let roundTB = userDefault.integer(forKey: "roundTB") + 1
        
            userDefault.set(roundTB, forKey: "roundTB")
             print("savedOnUserDef-RoundTB : \(roundTB)")
    }
    
    
    
  // end Configurazione LeaderBoard GameKit / BankRoll - Hands - Win Rate - Rebuy
    
    // Configurazione Achievement
    
   /* func loadAchievements() {
        
        GKAchievement.loadAchievements { achievements, error in
            
            guard error == nil else {return}
            
            print("AchievementCount:\(achievements?.count ?? 0)")
            
        }
    } */
  
    // end configurazione Achievement
    
   /* func betButton(bet:String,stepCount:Int) {
        
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
     
    } */
    
    /*func cButton() {
        
        self.bet = 0.0
        
        if !isPlayerInAllIn{self.payOutAmplificator = 2.0}
         // questo serve per resettare ed evitare che uno facendo all-in e poi cancellando, resti con il x6
        
    } */
    
   /* func allInButton(stepCount:Int,blueRectangle:Bool){
        
        if stepCount == 2 {
            self.bet = self.bankroll
            self.payOutAmplificator = 3.0 // l'All in PreFlop paga 2x il default
        
        } // Come Open Bet è un ALL IN
        
        // Nel post flop lavorano i due rettangoli
        
        else if stepCount == 4 {
            
            let localBetLimitOnFlop = blueRectangle ? 3.0 : self.betLimitOnFlop
            
            if (gameOpen * localBetLimitOnFlop) > self.bankroll {self.bet = self.bankroll } else {self.bet = (gameOpen * localBetLimitOnFlop)} // sul flop viene limitato
     
        }
        
        else if stepCount == 6 || stepCount == 7 {
            
            if (gameOpen * betLimitOnTurn) > self.bankroll {self.bet = self.bankroll } else {self.bet = (gameOpen * betLimitOnTurn)} // sul turn viene limitato
            
            
        }
        
    } */
    
   /* func potComposition(stepCount:Int) {
    
        self.pot += self.bet
        self.bankroll -= self.bet

        if stepCount == 2 {
            
            self.gameOpen = self.bet
            
        } // impostiamo l'apertura
        
        else {self.isBetLocked = true}
        
        self.bet = 0.0
        
    } */
    
   /* func cleanOrFoldAction() {
        
        self.hands += 1
        saveScores()
        self.pot = 0.0
        self.bet = 0.0
        self.winSeries = 0.0
        self.isBetLocked = false
      //  self.maniPerseFoldate += 1
        self.payOutAmplificator = 2.0
        self.betLimitOnTurn = 2.0
       
    } */
    
    func resultAttribution(playerWin: Bool, combination: PossibleResults) {
       
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
           combinationPoint = 25
       case .straight:
           combinationPoint = 25
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

   /* func reBuy() {
        
        self.rebuyAvaible = true
        self.rebuyCount += 1.0
        
        self.showAccessPoint(isActive: false)
    } */
    
   /* func achievementAccomplished(id:String) {
    
        let currentAchievement:GKAchievement = {
            
            let achievement = GKAchievement(identifier: id)
            
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
                    print("currentAchie \(id) salvato con successo")
                   // self.achievementsDone.append("red_001")
                }
    } */ // versione vecchia sostituita da un functionBuilder
    
    @AchievementManager
    func achievementAccomplished(id:String) {id}
    
    func winSeriesAchievment() {
        
        if self.winSeries == 3 { achievementAccomplished(id: "hit3times_011")}
        
        else if self.winSeries == 5 { achievementAccomplished(id: "hit5times_012")}
        
        else if self.winSeries == 7 {achievementAccomplished(id: "hit7times_013")}
        
        else if self.winSeries == 10 {achievementAccomplished(id: "hit10times_014")}
        
        else if self.winSeries == 15 {achievementAccomplished(id: "hit15times_015")}
        
    
    }
    
   func saveWinSeries(idLeaderBoard:String) {
        
        // save the best WinSeries in two Moment: 1. When player loose. 2. When the game finish
        
        let intWinSeries = Int(self.winSeries)
        
        GKLeaderboard.submitScore(intWinSeries, context: 1, player: GKLocalPlayer.local, leaderboardIDs: [idLeaderBoard]) { error in
            
            guard error == nil else {
                print("Error in submitScore to WinSeries:\(error.debugDescription.description)")
                return }
        }
    }
   
   /* func saveWithoutLeaderBoard(value:Int) {
        
        let stringValue = String(value)
        
        let data = Data(stringValue.utf8)
  
        GKLocalPlayer.local.saveGameData(data, withName: "BankrollTest") { savedGame, error in
            
            print(savedGame.debugDescription)
            if let saved = savedGame {
                print("Saved: \(saved.name ?? "NoValue")")
                print("Game Saved Successfully")}
            
            guard error == nil else {
                print("Error in saveData:\(error.debugDescription)")
                return
            }
            
            print("FileName Saved:\(savedGame?.name ?? "NoName")")
        }
        
        
    // In questa forma sembrerebbe funzionare. Il problema è che il dato viene salvato su icloud, il che funziona in modo separato rispetto al Game Center. Ossia, l'utente potrebbe essere loggato sul game center e non sul cloud e viceversa. Questo quindi provaca diversi problemi di gestione del dato, dato che a noi servirebbe poi recupararlo, non solo per le classifiche ma per gli score di gioco. Quindi, o salviamo i dati sul device ( e di questo avremmo certezza) o li continuiamo a salvare su Gamekit come classifiche.
        
    } */
  

}


