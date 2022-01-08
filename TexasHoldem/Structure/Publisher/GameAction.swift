//
//  GameAction.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 14/10/21.
//

import Foundation
import GameKit
import SwiftUI
import Firebase


class GameAction: ObservableObject {
    
   let timer = Timer.publish(every: 0.01, tolerance: .none, on: .main, in: .common, options: .none).autoconnect()
    @Published var timerSection:Float = TimerSection.base.rawValue {didSet{
        self.opacityBuilder()
        print("Valore timerSectionChanged inside Observer") } }// di default è uguale all'every del Timer, la varieremo sul receiver in base ai bonus per rallentare il gioco e permettere al player di ottenere più punteggi
    
    @Published var countDown:Float // secondi
    var storedCountDown:Float // è il valore del countdown al tempo t-1
    var winSeries:Float = 0 // è il numero di vittorie consecutive // usata in both the game per gli achievement
    var isGameEnded:Bool = false
    
    var handsTime:[Float] = [] // beta per vedere nel test la media delle risposte per creare un achievement
  //  var isDealButtonActive:Bool = false
     
    var tbGameLevel:GameLevelTB
    var tbPreLeaderBoard:LeaderBoardsName? = nil
    var tbCurrentLeaderBoard:LeaderBoardsName = .score60_001TB
    var colorTable:Color = Color(red: 0, green: 0.5603182912, blue: 0)
        
    func defaultBankroll() {self.bankroll = 0}
 
    // Variabili il cui valore viene recuperato dal server GameKit
    
    @Published var bankroll: Float = 0.0
    var storedBankRoll: Float = 0.0
    @Published var hands: Float = 0.0 // le mani totali giocate
    @Published var maniVinte:Float = 0.0 // qui contiamo le mani vinte // il valore lo importiamo dalla leaderBoard, ricavandolo dal WinRate salvato. Questo perchè il win rate qui è una computed, la maniVintePercent, il che, per ovviare all'impostazione di un setter, ricalcoliamo andando ad estrapolare questo valore e ricombinandolo con le maniGiocate (Hands), anch'esso un valore salvato nella leaderBoard. Valutiamo l'impostazione del setter in maniVintePercent
    
    @Published var rebuyCount:Float = 0.0 // Nel gioco classico stocca il numero di rebuy, nel gioco a tempo stocca il miglior Punteggio
    
    // STATIC
    static var roundTBcount:Int = 0 // conta i round di gioco TB
    static var isTBPremium:Bool = false 
  //  static var localPlayerAuth:Bool = false
  //  static var authFailed:Bool = false // qualora l'autenticazione fallisce, nei secondi ingressi l'autanticationHandler non parte e allora usiamo questo bool per ricaricare i valori.
    
    // fine variabili il cui valore è recuperato dal server GameKit
    var localPlayerAuth:Bool
    
    init(tbGameLevel:GameLevelTB,localPlayerAuth:Bool) {
        
        print("init in SuperClasse GameAction tbGameLevel:\(tbGameLevel) e localPlayerAuth: \(localPlayerAuth)")
        
        self.tbGameLevel = tbGameLevel
        self.countDown = tbGameLevel.rawValue
        self.storedCountDown = tbGameLevel.rawValue
        self.localPlayerAuth = localPlayerAuth
        self.tableANDScoreAssign()
        
        if localPlayerAuth {
            print("Probabile secondo ingresso con Player già autenticato")
            self.ifLocalPlayerIsAuth()}
        
      /* else if authFailed {
            print("Probabile secondo ingresso con autenticazione precedentemente FALLITA. Verifica: is PlayerAuth: \(GKLocalPlayer.local.isAuthenticated.description)")
           // self.defaultBankroll()
            
        }
        
        else {
            print("Probabile PROBLEMA")
           // self.authenticateUser()
            
        } */
        
    }
    
    func tableANDScoreAssign() {
        print("insideTableColor()")
        switch tbGameLevel {
            
        case .one:
            self.colorTable = Color(red: 0, green: 0.5603182912, blue: 0)
            self.tbCurrentLeaderBoard = .score60_001TB
            self.tbPreLeaderBoard = nil
            print("level1 in TableANd")
        case .two:
            self.colorTable = Color(red: 0.45, green: 0, blue: 0)
            self.tbCurrentLeaderBoard = .score45_002TB
            self.tbPreLeaderBoard = .score60_001TB
            print("level2 in TableANd")
        case .three:
            self.colorTable = Color(red: 0, green: 0.1, blue: 0.6)
            self.tbCurrentLeaderBoard = .score30_003TB
            self.tbPreLeaderBoard = .score45_002TB
            print("level3 in TableANd")
        case .four:
            self.colorTable = Color(red: 0.07, green: 0.07, blue: 0.07)
            self.tbCurrentLeaderBoard = .score15_004TB
            self.tbPreLeaderBoard = .score30_003TB
            print("level4 in TableANd")
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

    
    // LeaderBoard GameKit / BankRoll - Hands - Win Rate - Rebuy - Importiamo l'ultimo valore salvato nella leaderBoard.
    
    @Published var isLoading:Bool = false // ci serve a gestire le attese iniziali di autenticazione
    
    func ifLocalPlayerIsAuth() {
        
        print("inside method ifLocalPlayerIsAuth")
       
        self.showAccessPoint(isActive: true)
        self.updateScoresFromFirebase()
       // self.updateScores()
        
    }
    
   func resetForNewGame() {
        
        self.isGameEnded = false
        self.hands = 0
        self.maniVinte = 0
        self.bankroll = self.storedBankRoll
        self.countDown = self.tbGameLevel.rawValue
        self.storedCountDown = self.tbGameLevel.rawValue
        self.winSeries = 0
       
       self.timerSection = TimerSection.base.rawValue
       self.setDone = false
       self.straighFlushDone = false
       self.fujikoDone = false
       self.pokerDone = false
       self.straightDone = false
       self.flushDone = false
        
       self.handsTime = []
    }
    
    func compareScore() {
         
         if self.rebuyCount < self.bankroll {
             
             self.rebuyCount = self.bankroll
             self.saveScoreOnFirebase() // Salviamo qui su FireBase, perchè se lo mettiamo insieme al SaveOnGameKit rischiamo di sovrascrivere un punteggio più alto. Qui verrà salvato solo se effettivamente più alto.
         }
         
     }
 
    func showAccessPoint(isActive:Bool) {

        guard AuthPlayerGK.instance.localPlayerAuth else { return }
        
        GKAccessPoint.shared.isActive = isActive // appare anche se il localPlayer non si è autenticato. Non crea comunque un conflitto ed è buono per ricordare al giocatore di potersi loggare dentro.
        
    }
    
    func updateScoresFromFirebase() {
         
         let db = Firestore.firestore()
         
         let uniqueId = GKLocalPlayer.local.gamePlayerID
             
         db.collection("GotTheNutDataScore").document("\(uniqueId)").getDocument { document, error in
                 
                 guard error == nil else {return}
                 
         if document?.exists == true {
                     
             if let documentExist = document?.get(self.tbCurrentLeaderBoard.rawValue) as? Float {
                 
                 self.rebuyCount = documentExist
                 
             } else {self.rebuyCount = 0}
             
             if let preLeaderBoard = self.tbPreLeaderBoard {
                 
              //   self.bankroll = document?.get(preLeaderBoard.rawValue) as! Float
                 self.storedBankRoll = document?.get(preLeaderBoard.rawValue) as! Float
                 self.bankroll = self.storedBankRoll
                 
             } else {self.bankroll = 0}

                     
                 } else {
                     
                     print("Probabile primo Accesso Firebase. Player Non Ancora in DataBase")
                     
                 }
                 
                 }
    
     }

   /*  func updateScores() {
         print("Update Score leaderboard: \(self.tbCurrentLeaderBoard.rawValue)")
        
        let localPlayer = GKLocalPlayer.local
        
         localPlayer.setDefaultLeaderboardIdentifier(self.tbCurrentLeaderBoard.rawValue) { _ in
            print("Nuova leaderboard di Default: \(self.tbCurrentLeaderBoard.rawValue)")
        }
        
         GKLeaderboard.loadLeaderboards(IDs: [self.tbCurrentLeaderBoard.rawValue]) { leaderBoards, _ in
             print("inside update currentLeaderBoards \(self.tbCurrentLeaderBoard.rawValue) and preLeaderboard: \(self.tbPreLeaderBoard?.rawValue ?? "probably on level 1 or error")")
            
        leaderBoards?[0].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, error in

            print("leaderboardName:\(leaderBoards![0].title ?? "noName") and preLeaderBoard:\(leaderBoards![1].title ?? "noName[1]")")
                   guard error == nil else {return}
                
                   if player?.score != nil {
                       
                       print("player score != nil")
                       let importedScore = player?.score
                       let floatScore = Float(importedScore!)
                       self.rebuyCount = floatScore / 100 // nel rebuyCount salviamo il BestScore
                   }
               }
        }
    } */
    
   func saveScores() {
        
       guard self.localPlayerAuth else {
            
            print("In TB giocatore non loggato - Nessun Salvataggio su GameKit")
           // saveForAdsShow()
            return
        }
       self.saveScoresOnGameKit()
      //  saveForAdsShow()
        print("saveScores Overrided completamente")
     }
    
   func saveScoresOnGameKit() {
        
        print("saveScoresOnGameKit Overrided")
        
         // TimeBank LeaderBoard Score == RebuyCount
         
         let extendedScore = self.rebuyCount * 100
         let intScore = Int(extendedScore)
         
       GKLeaderboard.submitScore(intScore, context: 1, player: GKLocalPlayer.local, leaderboardIDs: [LeaderBoardsName.generalScore_005TBnew.rawValue]) { error in // salviamo sempre sulla stessa leaderBoards
             
             guard error == nil else {
                 print("Error in submitScore to ScoreTB:\(error.debugDescription.description)")
                 return }
         }
        
      //  saveWinSeries(idLeaderBoard: "007_winSeries")

     }
    
    func saveScoreOnFirebase() {
           
        guard self.localPlayerAuth else {
            print("inside SaveOnFirebase - Player NOn Authenticato")
            return}
        let db = Firestore.firestore()

           // Usiamo l'id del GameCenter, e non l'identifierForVendor, per permettere il recupero dati su device diversi, loggati sullo stesso GameCenter
           
        let uniqueIdentifier = GKLocalPlayer.local.gamePlayerID
               
        db.collection("GotTheNutDataScore").document("\(uniqueIdentifier)").setData([self.tbCurrentLeaderBoard.rawValue : self.rebuyCount],merge: true) { error in
                   
                   guard error == nil else {
                       print("error in saveScoreOnFirebase: \(error.debugDescription)")
                       return }
               }
               
        //   } else {print("UniqueDeviceId == nil") }
           
           
        print("SaveData for playerID: \(uniqueIdentifier) in leaderboard:\(self.tbCurrentLeaderBoard.rawValue)")
           
       }
    
   /* func saveWinSeries(idLeaderBoard:String) {
         
         // save the best WinSeries in two Moment: 1. When player loose. 2. When the game finish
         
         let intWinSeries = Int(self.winSeries)
         
         GKLeaderboard.submitScore(intWinSeries, context: 1, player: GKLocalPlayer.local, leaderboardIDs: [idLeaderBoard]) { error in
             
             guard error == nil else {
                 print("Error in submitScore to WinSeries:\(error.debugDescription.description)")
                 return }
         }
     } */
    
    /*func saveForAdsShow() {
        
            let userDefault = UserDefaults.standard
            
            let roundTB = userDefault.integer(forKey: "roundTB") + 1
        
            userDefault.set(roundTB, forKey: "roundTB")
             print("savedOnUserDef-RoundTB : \(roundTB)")
    } */
   @Published var setDone:Bool = false
   @Published var straighFlushDone:Bool = false
   @Published var fujikoDone:Bool = false
   @Published var pokerDone:Bool = false
   @Published var straightDone:Bool = false
   @Published var flushDone:Bool = false
    
    func resultAttribution(playerWin: Bool, combination: PossibleResults, nutCards:[String]) {
       
     self.showAccessPoint(isActive: true)
       
     let timeConsumed = self.storedCountDown - self.countDown
        
     if playerWin && timeConsumed <= 1.0 {achievementAccomplished(id: "fasterHand_006tb") } // Save Achievement faster hand
        
     let combinationPoint:Float
        
     self.handsTime.append(timeConsumed) // beta per testare il tempo di risposta e creare un achievement
        
       switch combination {
           
       case .straightFlush:
           combinationPoint = 40
           if playerWin {
               achievementAccomplished(id: "straightFlush_009tb")// saved achievement I get straight flush
               self.timerSection -= self.straighFlushDone ? 0 : TimerSection.booster_2.rawValue
               self.straighFlushDone = true
               if nutCards.contains("05p") && nutCards.contains("03p"){
                   self.timerSection -= self.fujikoDone ? 0 : TimerSection.booster_15.rawValue
                   self.fujikoDone = true
               }
           }
           print("timerSection-> \(self.timerSection) and nutCard:\(nutCards)")
       case .poker:
           combinationPoint = 15
           if playerWin {
               self.timerSection -= self.pokerDone ? 0 : TimerSection.booster_05.rawValue
               self.pokerDone = true
           }
       case .flush:
           combinationPoint = 25
           if playerWin {
               self.timerSection -= self.flushDone ? 0 : TimerSection.booster_05.rawValue
               self.flushDone = true
           }
       case .straight:
           combinationPoint = 25
           if playerWin {
               self.timerSection -= self.straightDone ? 0 : TimerSection.booster_05.rawValue
               self.straightDone = true
           }
       case .set:
           combinationPoint = 40
           if playerWin{
               achievementAccomplished(id: "setTheNut_010tb") // saved achievement Set the Nut
               self.timerSection -= self.setDone ? 0 : TimerSection.booster_2.rawValue
               self.setDone = true
           }
           print("timerSection-> \(self.timerSection) and nutCard:\(nutCards)")
       }
       
       if playerWin {
           
           self.winSeries += 1
          // if self.winSeries >= 15 {achievementAccomplished(id: "strike_007tb")} // saved achievement Amazing Strike
           self.checkWinSeriesAchievement()
           
           let acceleratoreBySeries = 1 + (1 - (1 / self.winSeries))
           let scoreFirstStep = combinationPoint * (1 + (3/timeConsumed))
           
           self.moneyWinOrLoose = scoreFirstStep * acceleratoreBySeries // score finale
        
           self.maniVinte += 1
       
           print("playerWIN -> timerSection:\(timerSection)")
       
       } else {
           
           // salvare il winSeries prima dell'azzeramento
          // saveWinSeries(idLeaderBoard: "007_winSeries")
           self.moneyWinOrLoose = 0
           self.winSeries = 0
           // Se il giocatore perde eventuali bonus vengono azzerati. Il che vuol dire che possono essere nuovamente presi
           self.timerSection = TimerSection.base.rawValue
           self.setDone = false
           self.straighFlushDone = false
           self.fujikoDone = false
           self.pokerDone = false
           self.straightDone = false
           self.flushDone = false
           print("playerLOOSE -> timerSection:\(timerSection)")
           
       } // in caso di errore, non si perde nulla e la serie vincente viene azzerata
       
       self.hands += 1
       self.bankroll += self.moneyWinOrLoose
        
      //  if self.bankroll >= 100/*1000*/ {achievementAccomplished(id: "scoreWall_008tb")} // saved achievement 1k Score Wall // achievement sospeso da quando abbiamo creato più livelli con general score cumulativo
       
   }
    
    @AchievementManager
    func achievementAccomplished(id:String) {id}
    
    var levelAchieDone:Bool = false
    
    func checkWinSeriesAchievement() {
          
        guard self.localPlayerAuth else {
            print("dentro WinSeriesAchievement. Player non autenticato")
            return
        }
        
        switch tbGameLevel {
            
        case .one:
            if !levelAchieDone && self.winSeries >= tbGameLevel.rawValue / 6.0 { // requisito per passare di livello
                achievementAccomplished(id: "level2_016tb")
              //  AuthPlayerGK.achievCount += 1
                AuthPlayerGK.instance.isLocked.level2 = false 
                self.levelAchieDone = true
            }
            if self.winSeries >= 15 {achievementAccomplished(id: "strike_007tb")} // saved achievement Amazing Strike
        case .two:
            if !levelAchieDone && self.winSeries >= tbGameLevel.rawValue / 5.0 {
                achievementAccomplished(id: "level3_017tb")
                AuthPlayerGK.instance.isLocked.level3 = false
              //  AuthPlayerGK.achievCount += 1
                self.levelAchieDone = true
            }
        case .three:
            if !levelAchieDone && self.winSeries >= tbGameLevel.rawValue / 4.0 {
                achievementAccomplished(id: "level4_018tb")
                AuthPlayerGK.instance.isLocked.level4 = false 
               // AuthPlayerGK.achievCount += 1
                self.levelAchieDone = true
            }
        case .four:
            if !levelAchieDone && self.winSeries >= tbGameLevel.rawValue / 3.0 { // requisito per vincere
                // disporre Achievment di Vittoria
                achievementAccomplished(id: "levelEnd_019tb")
              // AuthPlayerGK.achievCount += 1
                self.levelAchieDone = true
                print("Player Won All level") }

        }

      }
    
   /* @Published var opacity:(l1:Double,l2:Double,l3:Double,l4:Double,l5:Double,l6:Double,l7:Double) = {
    
        return(0.2,0.2,0.2,0.2,0.2,0.2,0.2)
        
    }() */
    
    @Published var opacity:((l1:Double,l1isLock:Bool),(l2:Double,l2isLock:Bool),(l3:Double,l3isLock:Bool),(l4:Double,l4isLock:Bool),(l5:Double,l5isLock:Bool),(l6:Double,l6isLock:Bool),(l7:Double,l7isLock:Bool)) = {
    
        return((0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false))
        
    }()
    
   // @State var opacityA:[Double] = [0.1,0.1,0.8,0.1,0.1,0.1,0.1]
    
    func opacityBuilder() {
        
        self.opacity = ((0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false),(0.2,false))
        
        let variazioneTimer_step1 = TimerSection.base.rawValue - self.timerSection
        let variazioneTimer_step2 = (Double(variazioneTimer_step1) * 10000) //otteniamo il numero di slot opacity occupati dalla variazione (max 14)
        let intStep_2 = Int(variazioneTimer_step2)
        var doubleAgainStep2 = Double(intStep_2) / 10.0
        
        while doubleAgainStep2 > 0 {
            
            print("Start ciclo while - step2Value:\(doubleAgainStep2)")
            
            if opacity.0.l1 < 1.0 && !opacity.0.l1isLock {
                opacity.0.l1 += 0.4
                doubleAgainStep2 -= 0.5
                print("inside opacity.l1 - step2:\(doubleAgainStep2)")
                
            }
            
            else if opacity.1.l2 < 1.0 && !opacity.1.l2isLock {
                
                opacity.0.l1isLock = true
                
                opacity.1.l2 += 0.4
                opacity.0.l1 -= 0.45
                doubleAgainStep2 -= 0.5
                
                print("inside opacity.l2 - step2:\(doubleAgainStep2)")
            }
            
            else if opacity.2.l3 < 1.0 && !opacity.2.l3isLock {
                
                opacity.1.l2isLock = true
                
                opacity.2.l3 += 0.4
                opacity.1.l2 -= 0.4
                doubleAgainStep2 -= 0.5
                print("inside opacity.l3 - step2:\(doubleAgainStep2)")
            }
            
            else if opacity.3.l4 < 1.0 && !opacity.3.l4isLock {
                
                opacity.2.l3isLock = true
                
                opacity.3.l4 += 0.4
                opacity.2.l3 -= 0.35
                doubleAgainStep2 -= 0.5
                print("inside opacity.l4 - step2:\(doubleAgainStep2)")
            }
            
            else if opacity.4.l5 < 1.0 && !opacity.4.l5isLock {
                
                opacity.3.l4isLock = true
                
                opacity.4.l5 += 0.4
                opacity.3.l4 -= 0.30
                doubleAgainStep2 -= 0.5
                print("inside opacity.l5 - step2:\(doubleAgainStep2)")
            }
            
            else if opacity.5.l6 < 1.0 && !opacity.5.l6isLock {
                
                opacity.4.l5isLock = true
                
                opacity.5.l6 += 0.4
                opacity.4.l5 -= 0.25
                doubleAgainStep2 -= 0.5
                print("inside opacity.l6 - step2:\(doubleAgainStep2)")
            }
            
            else if opacity.6.l7 < 1.0 && !opacity.6.l7isLock {
                
                opacity.5.l6isLock = true
                
                opacity.6.l7 += 0.4
                opacity.5.l6 -= 0.2
                doubleAgainStep2 -= 0.5
                print("inside opacity.l7 - step2:\(doubleAgainStep2)")
            }
            
            
        }
        
        print("insideOpacityBuilder")
        
    }
    
  

}


