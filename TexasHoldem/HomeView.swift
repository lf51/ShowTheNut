//
//  HomeView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import SwiftUI

/*
 
 !!! TERMINATO 04.12.2021
 Verificare nel debug la consecuzio dei metodi attraverso i print e operare una prima/veloce pulizia del codice
 
 Errore che non ci spieghiamo(Appare solo quando entriamo in Classic -- sia primo accesso che secondario--- non appare in TimeBank -- ne in primo accesso ne in secondo --):
 
 2021-12-04 17:48:06.350967+0100 TexasHoldem[37328:12095702] [Error] No platform string for specified GKGamePlatform value (0), defaulting to iOS.

 - Modificare le Rules --> √ Fatto
 
 
 */


struct HomeView: View {
    
    var screenWidth:CGFloat = UIScreen.main.bounds.width
    var screenHeight:CGFloat = UIScreen.main.bounds.height
    
    @Binding var gameChoice: Int
    @State private var isPremium:Bool = true
    
    var body: some View {
     
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack{
                
                Button {
                    
                    self.gameChoice = 1
                    
                } label: {
                    ClassicGameSelectionView(screenWidth: screenWidth, screenHeight: screenHeight)
                }
           
                Button {
                    
                    self.gameChoice = 2
                    
                } label: {
                    TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight, isPremium: isPremium)
                }.disabled(!isPremium)
     
            }
            
            Text("Show The Nut")
                    .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.yellow)
                    .frame(maxWidth:screenWidth)
                    .frame(height: screenWidth * 0.12, alignment: .center)
                    .padding()
                    .background(Color(CGColor(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5))
        }
    }
    
}

/*struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} */


