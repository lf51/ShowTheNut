//
//  ItalianRulesView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 31/10/21.
//

import SwiftUI

struct ItalianRulesView: View {
    
    var fontSize: Double
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Show the Nut")
                .font(.system(size: fontSize * 1.3, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
                .padding(.bottom)
            
            Text("Questo gioco è una variante del Poker Texas Hold'em caratterizzata dalla possibilità di scegliere le proprie carte dopo aver visto il Flop.\n")
            
            Text("Regole\n")
                .font(.system(size: fontSize * 1.2, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
            
            Text("• Pre-Flop: \nil giocatore apre il gioco con una scommessa no limits;\nse il giocatore apre in All-in, il moltiplicatore standard viene raddoppiato.\n\n• Flop:\nil giocatore sceglie le proprie carte.\nLa puntata, opzionale, è limitata a 3x o 5x rispetto l'apertura.\n\n• Turn:\nla scommessa sul turn è possibile solo in caso di check sul flop. In ogni caso il giocatore ha la possibilità di sostituire una delle proprie carte, riducendo però il moltiplicatore di vittoria e cambiando il limite della scommessa.\nL'eventuale scommessa è limitata a 2x rispetto l'apertura, o, nel caso di cambio carta, a 0.5x rispetto l'apertura.\n\n• River:\nil giocatore vince se ottiene la combinazione più alta, il Nut.\n\n\nMoltiplicatore di Vittoria:\n• Standard -> 2x Piatto\n")
            
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
