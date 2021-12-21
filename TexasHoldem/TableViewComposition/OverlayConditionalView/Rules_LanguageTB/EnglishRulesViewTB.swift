//
//  EnglishRulesView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 31/10/21.
//

import SwiftUI

struct EnglishRulesViewTB: View {
    
    var fontSize: Double
    
    var body: some View {
        
        VStack {
          //  Spacer()
            
            Text("Get the Nut") // Show the Nut // Hunt the Nut //
                .font(.system(size: fontSize * 1.4, weight: .bold, design: .monospaced))
                .foregroundColor(Color.purple)
                .padding(.vertical)
            
            Text("• Level 1 -> 10 Nuts in 60' to level 2\n• Level 2 -> 9 Nuts in 45' to level 3\n• Level 3 -> 8 Nuts in 30' to level 4\n• Level 4 -> 5 Nut in 15' to complete\n\n")
            
            Text("Rules")
                .font(.system(size: fontSize * 1.2, weight: .bold, design: .monospaced))
                 .foregroundColor(Color.purple)
                 .padding(.bottom)
                        
            Text("• In each level the player has a time bank to match as many 'Nut Hand' as possible;\n\n• the player can choose the cards soon after the flop;\n\n• time slows down with the achievement of the following points:\n\n• Straight flush -> 20%\n• Straigh Flush with 5/3 of spades -> 15% (plus Straigh flush bonus if not already done)\n• Set -> 20%\n• Quads/Flush/Straigh -> 5%\n\n• Bonuses are obtainable only once and are cumulative;\n• max bonus -> 70%;\n• in the event of an error, the bonuses are reset and can be obtained again;\n• to the right of the timer is the bonus indicator.")
            
           
            
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
