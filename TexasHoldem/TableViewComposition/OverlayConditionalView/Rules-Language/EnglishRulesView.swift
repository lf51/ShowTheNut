//
//  EnglishRulesView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 31/10/21.
//

import SwiftUI

struct EnglishRulesView: View {
    
    var fontSize: Double
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Show the Nut") // Show the Nut // Hunt the Nut //
                .font(.system(size: fontSize * 1.3, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
                .padding(.bottom)
            
            Text("The game is a variation of Poker Texas Hold'em since the player chooses his pocket cards after the Flop.\n")
            
            Text("Rules\n")
                .font(.system(size: fontSize * 1.2, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
            
            Text("• Pre-Flop: \nthe player open the game with a no limits bet;\nif the Opening Bet is All-in, the win multiplier is Double.\n\n• Flop:\nthe player chooses the pocket cards. Bet is 3x or 5x Opening Bet limited.\n\n• Turn:\nbet is 2x Opening Bet limited. The player can change one of the pocket cards, in this case the win multiplier change too, and the bet is 0.5x Opening Bet limited.\n\n• River:\nthe player wins if he finally gets the nut, the highest possible hand.\n\n\nWin multiplier:\n• Standard -> 2x Pot\n")

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
