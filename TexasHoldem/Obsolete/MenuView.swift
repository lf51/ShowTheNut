//
//  GameTester.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 01/11/21.
//

import Foundation
import SwiftUI
import GameKit

// Usare la calssifica al punteggio più recente. Dovrebbe così darmi ad ogni mano il valore corrente del bankroll. PROVARE !!!

// Mettere gli achievement, creando degli step con i colori del tavolo e il valore delle chips.

// TROVARE UN NOME !!!!! Show the Nut // The Nut Show

struct MenuView: View {
    
    @StateObject var ga:GameAction = GameAction()
    
    let localPlayer = GKLocalPlayer.local
    
    func authenticateUser() {
        
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
      
        }
    }
    
    func updateScore() {
     
        GKLeaderboard.loadLeaderboards(IDs: ["001_bankroll"]) { leaderBoards, error in
            
            guard error != nil else {
                
                print(error.debugDescription)
                return
            }
            
            if leaderBoards?[0] != nil {
                
                leaderBoards?[0].loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { player, _, _ in
                    
                    ga.bankroll = Float(player?.score ?? 212)
                    
                }
                
            } else {print("leaderBoards è nil") }
         
        }
            
        }
    
        
    /*    leaderBoard.loadEntries(for: [localPlayer], timeScope: GKLeaderboard.TimeScope.allTime) { lastScore, scores, error in
            guard error != nil else {return}
            
            print("\(lastScore?.score)")
            let newBankroll = Float(lastScore?.score ?? 212)
            ga.bankroll = newBankroll
        } */
    

    
    var body: some View {
        
       // TableView(ga:ga)
       // .onAppear {
         //   authenticateUser()
         //   updateScore()
          
       // }
        Text("Hello")
    }
}
