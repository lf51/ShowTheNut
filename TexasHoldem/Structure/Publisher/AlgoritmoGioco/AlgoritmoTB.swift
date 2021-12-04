//
//  TimeBankGameAlgo.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import Foundation

class AlgoritmoTB:AlgoritmoGioco {
    
    override func shuffleUp() {
        
        print("shuffleUp ovveride")

        cleanOrFoldAction()
        
        self.stepCount = 1
        
        for time in stride(from: 0.0, to: 5.0, by: 1.0) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                
                SoundManager.instance.playSound(sound: .cardShuffler) // Tutti gli shuffler registrati risultano fastidiosi
                self.shuffledCards.shuffle()
  
                if time == 4.0 {
                    self.stopShuffle = true
     
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        (self.temporaryStudCards, self.mazzoA, self.mazzoB) = self.smazzata()
                   
                        self.shuffledCards.shuffle() // questa Shufflata ci serve per aggiornare il Published nel ForEach, il mazzo è stato già creato con la smazzata()
      
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.mazzoA = self.temporaryStudCards
                         
    /* Linea Corretta */   self.shuffledCards = self.temporaryStudCards // Qui abbiamo il mazzo smazzato con cui giocare
                            
    /* LINEA TEST */ // self.shuffledCards = self.mazzoTest // Da eliminare
  
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.deal()
                            }
                            
                            
               
                        }
                    }
                }
            })
        }
    }
    
    override func deal() {
        print("deal ovveride")
        // In questa versione uniamo flop turn e river
            self.isFlopReady = true
            self.showStudCards = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: DispatchWorkItem(block: {
            self.flop[0] = self.shuffledCards[0]
            SoundManager.instance.playSound(sound: .cardClip)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: DispatchWorkItem(block: {
            self.flop[1] = self.shuffledCards[1]
            SoundManager.instance.playSound(sound: .cardClip)
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: DispatchWorkItem(block: {
            self.flop[2] = self.shuffledCards[2]
            SoundManager.instance.playSound(sound: .cardClip)
            
            self.isTurnReady = true
            //self.startCountDown = true // il giocatore può iniziare a rispondere // Parte il countDown
            self.stepCount = 2
            self.areCardsUnpickable = false
            
        }))
        
     /*   DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: DispatchWorkItem(block: {
            self.isTurnReady = true
            //self.startCountDown = true // il giocatore può iniziare a rispondere // Parte il countDown
            self.stepCount = 2
            self.areCardsUnpickable = false
        })) */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: DispatchWorkItem(block: {
            
            self.shuffledCards.removeAll { card in
                self.myCards.contains(card)
             }
            
            self.turn = self.shuffledCards[3]
            SoundManager.instance.playSound(sound: .cardClip)
            self.isRiverReady = true
        }))
        
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 5.5, execute: DispatchWorkItem(block: {
            self.isRiverReady = true
        }))*/
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: DispatchWorkItem(block: {
            
            self.shuffledCards.removeAll { card in
                self.myCards.contains(card)
             }
            
            self.river = self.shuffledCards[5]
            
            if self.stepCount == 3 {self.nutsCalculator()}
            else {self.stepCount = 4}
            SoundManager.instance.playSound(sound: .cardClip)
        }))

    }
    
    override func pickACard(card: String) {
        
        print("pickCardOverrided")
        
        if self.myCards[0] == "retroCarta2" {
           
            if self.stepCount == 4 {SoundManager.instance.playSound(sound: .cardClip)} 
            self.myCards[0] = card
            
        }
        
        else {
            
          //  SoundManager.instance.playSound(sound: .cardClip)
            guard self.myCards[0] != card else {return}
            self.myCards[1] = card
            self.areCardsUnpickable = true
           
            if self.stepCount == 4 {
                
                SoundManager.instance.playSound(sound: .cardClip)
                
                self.stepCount = 3
                nutsCalculator()
                
            }
            else {self.stepCount = 3}
        }
    }
}
