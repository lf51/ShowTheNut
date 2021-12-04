//
//  ScoreView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct ScoreViewTB: View {
    
    @ObservedObject var ga: GameAction
  //  @ObservedObject var gl: GameLevel
    
    var screenWidth = UIScreen.main.bounds.width
    var idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var rectangleHeight:CGFloat {
        
        if idiomDevice == .pad {
            
          return screenWidth / 9.1618
            
        } else {
            
           return screenWidth / 4.1618
        }
        
    }
    
    var body: some View {
        
        ZStack{

            Rectangle()
                .frame(width: screenWidth, height: rectangleHeight, alignment: .center)
                .foregroundColor(.black)
                .opacity(0.6)
                .ignoresSafeArea()
 
            HStack{
                
                Group{
                    
                    Spacer()

                    StatRectangleOnTopView(idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight,textA: "Score",textB: ga.bankroll,specifier: "%.2f",color: Color.green)
    
                    Spacer()
                    
                    StatRectangleOnTopView(idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight,textA: "Hands",textB: ga.hands,specifier: "%.0f",color: Color.blue)
                    
      
                }
 
                Spacer()
                
             /*   if idiomDevice == .pad {
                    
                    PotOnPadView(ga: ga, gl: gl, idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight)
                    
                       Spacer()
                } */

                Group {
                    
                    
                    StatRectangleOnTopView(idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight,textA: "Wins %",textB: ga.maniVintePercent,specifier: "%.2f",color: Color.green)

                    Spacer()
                    
                    StatRectangleOnTopView(idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight, textA: "Best Score", textB: ga.rebuyCount, specifier: "%.2f", color: Color.red)
    
                    Spacer()
                }
                
                
            }
                           
            
    }
}

}
