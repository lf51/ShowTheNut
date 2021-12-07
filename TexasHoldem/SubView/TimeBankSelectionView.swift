//
//  TimeBankSelectionView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/11/21.
//

import SwiftUI

struct TimeBankSelectionView: View {
    
    var screenWidth:CGFloat
    var screenHeight:CGFloat
    
    // Animazione
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var scaleDimension: CGFloat = 1.0
    @State var rotationAngle: Double = -2.0
    // end Animation
    var isPremium:Bool
    
    var body: some View {
        
        ZStack {
            
            Image("ClassicGame")
                .resizable()
                .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                .opacity(0.2)
                .edgesIgnoringSafeArea(.bottom)
            
            Image(systemName: "clock.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.yellow)
                .padding()
                .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                .opacity(0.2)
                .edgesIgnoringSafeArea(.bottom)
            
            VStack {
  
                Text("TimeBank 60'")
                    .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(CGColor(red: 1, green: 1, blue: 1, alpha: 1)))
                    .scaleEffect(scaleDimension)
                    .rotationEffect(.degrees(rotationAngle))
                    .padding(.top, screenWidth / 2)
                
                HStack {
                    Image(systemName: isPremium ? "lock.open" : "lock")
                    Text("0/5 left")
                }
                .font(.system(size: screenWidth * 0.05, weight: .bold, design: .monospaced))
                .foregroundColor(Color(CGColor(red: 1, green: 1, blue: 1, alpha: 1)))
               // .padding(.top, screenWidth / 2)
            }
            
        }.onReceive(timer) { _ in
            
            withAnimation(.easeInOut(duration: 0.5)) {
                
                if isPremium {
                    
                    scaleDimension = scaleDimension == 1.0 ? 0.9 : scaleDimension + 0.1
                    rotationAngle = rotationAngle == -2 ? 2.0 : rotationAngle - 4.0
                
                } else {
                    
                    scaleDimension = 1.0
                    rotationAngle = 0.0
                    
                }
                
            }
        }
    }
}

/*struct TimeBankSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeBankSelectionView()
    }
}*/
