//
//  EnglishRulesView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 31/10/21.
//

import SwiftUI

struct ItalianRulesViewTB: View {
    
    var fontSize: Double
    
    var body: some View {
        
        VStack {
          //  Spacer()
            
            Text("Show The Nut") // Show the Nut // Hunt the Nut //
                .font(.system(size: fontSize * 1.4, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
                .padding(.vertical)
            
            Text("• Livello 1 -> 10 Nuts in 60' per il livello 2\n• Livello 2 -> 9 Nuts in 45' per il livello 3\n• Livello 3 -> 8 Nuts in 30' per il livello 4\n• Livello 4 -> 5 Nuts in 15' per completare\n\n")
            
            Text("Regole")
                .font(.system(size: fontSize * 1.2, weight: .bold, design: .monospaced))
                 .foregroundColor(Color.purple)
                 .padding(.bottom)
                        
            Text("• Per ogni livello di gioco si dispone di un timebank per indovinare quante più 'Mani Nut' possibili;\n\n• il giocatore ha facoltà di scegliere le proprie carte subito dopo il flop;\n\n• il tempo rallenta con l'ottenimento dei seguenti punti:\n\n• Scala reale -> 20%\n• Scala reale con 5/3 di picche -> 15% (oltre bonus Scala reale se non già ottenuto)\n• Set -> 20%\n• Poker/Scala/Colore -> 5%\n\n• I bonus sono ottenibili una sola volta e sono cumulativi;\n• bonus Massimo -> 70%\n• in caso di errore i bonus si azzerano e possono essere ottenuti nuovamente;\n• alla destra del timer il giocatore può visualizzare l'intensità del bonus.")
            
           
            
           /* Text("• Pre-Flop: \nthe player open the game with a no limits bet;\nif the Opening Bet is All-in, the win multiplier is Double.\n\n• Flop:\nthe player chooses the pocket cards. Bet is 5x Opening Bet limited.\n\n• Turn:\nthe player can change one of the pocket cards (half win multiplier). Bet is 3x Opening Bet limited.\n\n• River:\nthe player wins if he finally gets the nut, the highest possible hand.\n\n\nWin multiplier:\n• Standard -> 3x Pot\n• Double -> 6x Pot\n• Half -> 1.5x Pot") */

            Spacer()
            
        }
        .shadow(color: Color.black, radius: 5.0, x: 0.0, y: 0.0)
        .font(.system(size: fontSize, weight: .bold, design: .monospaced))
        .foregroundColor(Color.yellow)
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(0.1)
        .padding()
    }
}


