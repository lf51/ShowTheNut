//
//  ButtonCoronaBonus.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 19/12/21.
//

import SwiftUI

struct TimerFreezingIndicator: View {
    
    @ObservedObject var ga:GameAction
    var imageSize:Double

    init(ga:GameAction,screenWidth:CGFloat) {
        
        self.ga = ga
        self.imageSize = screenWidth * 0.08
        
    }

 
    var body: some View {

      //  ZStack {
            
      //      Color.black.ignoresSafeArea()
            
            
            VStack(spacing:-(imageSize/2.0)){
                
               Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.6.l7).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.5.l6).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.4.l5).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.3.l4).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.2.l3).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.1.l2).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
                
                Image(systemName: "snowflake")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .opacity(ga.opacity.0.l1).animation(Animation.linear(duration: 1.0), value: ga.timerSection)
              
            }
     
    }
}

struct ButtonCoronaBonus_Previews: PreviewProvider {
    static var previews: some View {
        TimerFreezingIndicator(ga: GameAction(tbGameLevel:.one, localPlayerAuth: false), screenWidth: 350)
    }
}
