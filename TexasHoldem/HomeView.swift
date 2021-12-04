//
//  HomeView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import SwiftUI

struct HomeView: View {
    
    var screenWidth:CGFloat = UIScreen.main.bounds.width
    var screenHeight:CGFloat = UIScreen.main.bounds.height
    
    @Binding var gameChoice: Int
    
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
                    TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight)
                }
     
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


