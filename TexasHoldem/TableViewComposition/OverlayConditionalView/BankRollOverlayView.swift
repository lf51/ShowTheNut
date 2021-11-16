//
//  BankRollOverlayView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 30/10/21.
//

import SwiftUI

struct BankRollOverlayView: View {
    
    @ObservedObject var ga:GameAction
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    @State private var count: Int = 10
    @State private var finishedText: String? = nil
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.6)//.ignoresSafeArea()
                .blur(radius: 30.0, opaque: false)
                .cornerRadius(30.0)
 
            VStack {
                
                Text(finishedText ?? "\(count)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)  // Usati insieme questi modifier permettono di tenere tutto su una linea

                
            }
            .font(.system(size: 100.0, weight: .bold, design: .monospaced))
            .foregroundColor(Color.white)
            .padding()
            
        }
        .onReceive(timer, perform: { _ in
            if count == 0 {
                
                ga.bankroll = 200.0
                finishedText = "+ \(String(ga.bankroll)) $"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ga.saveScores()
                    ga.rebuyAvaible = false
                }
                
            } else {
                count -= 1
            }
        })
    }
}
