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
    // TimeBankGA --> Abbiamo messo le proprietà e i metodi qui e non nella sottoclasse di appartenenza perchè quando chiamiamo i suddetti metodi e proprietà nelle view ci ritorna un errore. Nelle view noi usiamo la superclasse, e poi in base al gioco che si utilizza passiamo o la superclasse o la sottoclasse. Nei casi in cui passiamo la sottoclasse, i metodi e le proprietà richiamate non vengono trovate nella sottoclasse a meno di questo escamotage. Esempio: in una view condivise fra i due giochi dobbiamo accedere (esempio) a countdown. Usereme -- ga.countdown -- ga è definita nella view come una GameAction property. Dunque accederemo al countdown in entrambi i casi, sia qualora fossimo nel gioco classico che nel timebank. Ma il countdown ci serve solo per il gioco a tempo. Se spostiamo questa proprietà nella sottoclasse, nella view ricaviamo un errore perchè la ga.countdown non verrebbe più trovata in quanto il sistema accede alla superclasse. Dovremmo inizializzare la ga nella view come una GameActionTB, ma poi avremmo problemi con la Classic. Questo problema è molto probabilmente superato con protocolli e strutture, ma qui non possiamo provarlo perchè ci servono come Observer.
    
   let timer = Timer.publish(every: 0.01, tolerance: .none, on: .main, in: .common, options: .none).autoconnect()
    
    @Published var countDown:Float = 60.0 // secondi
    var storedCountDown:Float = 60.0 // è il valore del countdown al tempo t-1
    var winSeries:Float = 0 // è il numero di vittorie consecutive // usata in both the game per gli achievement
    var isGameEnded:Bool = false
    
    var handsTime:[Float] = [] // beta per vedere nel test la media delle risposte per creare un achievement
  //  var isDealButtonActive:Bool = false
     
    func resetForNewGame() {} // ovverided in TimeBankGA
    func defaultBankroll() {self.bankroll = 200} // to be overrided
    func compareScore() {} // to be overrided
    func resultAttribution (playerWin:Bool, combination:PossibleResults) {} // per il gioco TimeBank. Ovverided nella sottoclasse
    
    //
    
    // Variabili il cui valore viene recuperato dal server GameKit
    
    @Published var bankroll: Float = 0.0
    @Published var hands: Float = 0.0 // le mani totali giocate
    @Published var maniVinte:Float = 0.0 // qui contiamo le mani vinte // il valore lo importiamo dalla leaderBoard, ricavandolo dal WinRate salvato. Questo perchè il win rate qui è una computed, la maniVintePercent, il che, per ovviare all'impostazione di un setter, ricalcoliamo andando ad estrapolare questo valore e ricombinandolo con le maniGiocate (Hands), anch'esso un valore salvato nella leaderBoard. Valutiamo l'impostazione del setter in maniVintePercent
    
    @Published var rebuyCount:Float = 0.0 // Nel gioco classico stocca il numero di rebuy, nel gioco a tempo stocca il miglior Punteggio
    static var localPlayerAuth:Bool = false
    static var authFailed:Bool = false // qualora l'autenticazione fallisce, nei secondi ingressi l'autanticationHandler non parte e allora usiamo questo bool per ricaricare i valori.
    
    // fine variabili il cui valore è recuperato dal server GameKit
    
    init() {
        print("init in SuperClasse e authFailed: \(GameAction.authFailed) e localPlayerAuth: \(GameAction.localPlayerAuth)")
        
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
    
  /*  deinit {
        print("in deinit is LocalPlayerAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
        print("deinit GameAction SuperClass") } */

    @Published var pot:Float = 0.0
    @Published var bet: Float = 0.0
      
  //  var folds: Float {(maniPerseFoldate / hands) * 100} // tolta, vedi maniPerseFoldate
    var maniVintePercent: Float {(maniVinte / hands) * 100} // qui rendiamo in termini percentuali le mani vinte sulle mani totali
    
  // var maniPerseFoldate:Float = 0.0 // tolta perchè non serve. Basta cononoscere la percentuale di mani Vinte
    
    var gameOpen:Float = 0.0 // Apertura gioco
    var betLimitOnFlop: Float = 5.0 // sul flop 5x di Default rispetto al Game Open
    var betLimitOnTurn:Float = 2.0 // sul turn 2x di Default rispetto al GameOpen
    
    @Published var rebuyAvaible:Bool = false
   
    var moneyWinOrLoose: Float = 0.0 // vittoriaOrSconfitta
    @Published var payOutAmplificator: Float = 2.0 // Di Default si vince 3x rispetto al Pot
    
  //  @Published var isTherePayOutReduction:Bool = false // mettiamo Published perchè cosi' mi si aggiorna in tempo reale
    
    var isPlayerInAllIn:Bool {
        
        self.bankroll == 0
        
    } // questo ci serve per bloccare il reset sul cButton in caso di All-In
    
    @Published var isBetLocked:Bool = false
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
           
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.setDefaultLeaderboardIdentifier("001_bankroll") { error in
            
            guard error == nil else {
                print("error in setting LeaderBoard: \(error.debugDescription)")
                return}
            
            print("Nuova leaderboard di Default")
        }
        
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

                       print("hands:\(self.hands) uploaded")
                   
                   }
               }
            
            // load Rebuy
            
            leaderBoards?[3].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
                
             //   print("importedScore: \(player?.score)")
                guard error == nil else {return}
                
                if player?.score != nil {
                    
                    let importedScore = player?.score
                    self.rebuyCount = Float(importedScore!)
              
                    print("rebuyCount:\(self.rebuyCount) uploaded")
                
                }
            }

            // load Win Rate / bankroll // gli diamo uno stacco con il Dispatch perchè altrimenti si accavallano e non fa in tempo ad aggiornare le hands e i rebuy.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                leaderBoards?[1].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in
         
                     guard error == nil else {return}
                     
                     if player?.score != nil {
                         
                         let importedScore = player?.score
                         let floatScore = Float(importedScore!)
                      //   print("Float score: \(floatScore)")
                         let ultimateScore = floatScore / 10000
                         print("mani totali dentro complationHandler [1]:\(self.hands)")
                         self.maniVinte = self.hands * ultimateScore
                         
                         print("maniVinte:\(self.maniVinte) uploaded")
                     
                     }
                 }
                
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
                      print("bankroll:\(self.bankroll) uploaded")
                    
                    } // else {self.bankroll = 200 }
                }
                
                
            }
        }
    }
    
    func saveScores() {
        
        // Win Series Classic Game
        self.saveWinSeries(idLeaderBoard: "006_winSeriesClassic")
        
        // LeaderBoard Bankroll
        let netBankroll = (self.bankroll - 200) - (200 * self.rebuyCount) // sottraiamo al bankroll la posta iniziale e poi 200 per ogni rebuy
        
        let extendedBankroll = netBankroll * 100 // spostiamo la virgola di due posizioni
        let intBankroll = Int(extendedBankroll)  // trasformiamo in intero di modo da eliminare la virgola. Quando sarà attribuito alla classifica, in questa verranno messe due posizioni decimali (dal GameKit) e il numero sarà così uguale all'originale
        
        GKLeaderboard.submitScore(intBankroll, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["001_bankroll"]) { error in
            
            guard error == nil else {
                print("Error in submitScore to Bankroll:\(error.debugDescription.description)")
                return }
        }

        // !!!! TEST !!!!!! salvataggio in CloudGameCenter?
    
        
       // self.saveWithoutLeaderBoard(value:intBankroll)
        
        
        // end Test
        
        
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
    
   /* func loadAchievements() {
        
        GKAchievement.loadAchievements { achievements, error in
            
            guard error == nil else {return}
            
            print("AchievementCount:\(achievements?.count ?? 0)")
            
        }
    } */
  
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
        
        if !isPlayerInAllIn{self.payOutAmplificator = 2.0}
         // questo serve per resettare ed evitare che uno facendo all-in e poi cancellando, resti con il x6
        
    }
    
    func allInButton(stepCount:Int,blueRectangle:Bool){
        
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
        
    }
    
    func potComposition(stepCount:Int) {
    
        self.pot += self.bet
        self.bankroll -= self.bet

        if stepCount == 2 {
            
            self.gameOpen = self.bet
            
        } // impostiamo l'apertura
        
        else {self.isBetLocked = true}
        
        self.bet = 0.0
        
    }
    
    func cleanOrFoldAction() {
        
        self.hands += 1
        saveScores()
        self.pot = 0.0
        self.bet = 0.0
        self.winSeries = 0.0
        self.isBetLocked = false
      //  self.maniPerseFoldate += 1
        self.payOutAmplificator = 2.0
        self.betLimitOnTurn = 2.0
       
    }
    
    func resultAttribution(playerWin:Bool) {
        
        self.showAccessPoint(isActive: true)
        
        if playerWin {
            
           // self.moneyWinOrLoose = (self.pot * self.payOutRate)
            self.moneyWinOrLoose = (self.pot * self.payOutAmplificator)
            
            self.bankroll += self.moneyWinOrLoose
            
            self.maniVinte += 1
            self.winSeries += 1
            
            self.winSeriesAchievment()
            // salvare eventuale achievement
            
        } else {
            
            self.saveWinSeries(idLeaderBoard: "006_winSeriesClassic")
            self.moneyWinOrLoose = self.pot
            self.winSeries = 0
         //   self.maniPerseFoldate += 1
            
        }
        
        self.hands += 1
        saveScores()
        self.pot = 0.0
        self.bet = 0.0
        self.isBetLocked = false 
        self.payOutAmplificator = 2.0
        self.betLimitOnTurn = 2.0
        
    }

    func reBuy() {
        
        self.rebuyAvaible = true
        self.rebuyCount += 1.0
        
        self.showAccessPoint(isActive: false)
    }
    
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


