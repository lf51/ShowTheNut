//
//  Estensioni.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 14/11/21.
//

import Foundation

/*

DUE VARIANTI TIMEBANK:
 
 • Gioco a tempo con TIMEBANK in single Player. Indovinare il Nut
 • Sfida multiplayer.

 */


extension AlgoritmoGioco {
    
    func shuffleUpAndDeal() {
        
        shuffleUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.deal()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
            self.showTurn()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 13.0) {
            self.showRiver()
        }
        
        
        
        
    }
    
    
}
