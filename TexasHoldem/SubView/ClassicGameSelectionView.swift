//
//  ClassicGameSelectionView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/11/21.
//

import SwiftUI

struct ClassicGameSelectionView: View {
    
    var screenWidth:CGFloat
    var screenHeight:CGFloat
    
    // Animazione
  //  let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
  //  @State var scaleDimension: CGFloat = 1.0
  //  @State var rotationAngle: Double = 2.0
    // end Animation
    
    var body: some View {
        
        ZStack {
            
            Image("ClassicGame")
                .resizable()
                .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                .opacity(0.8)
                .ignoresSafeArea()
            
        /*   Text("Show The Nut")
                .font(.system(size: screenWidth * 0.15, weight: .bold, design: .monospaced))
                .foregroundColor(Color.yellow)
                .lineLimit(1)
                .minimumScaleFactor(0.1) */
               // .foregroundColor(Color(CGColor(red: 1, green: 1, blue: 1, alpha: 1)))
               // .scaleEffect(scaleDimension)
               // .rotationEffect(.degrees(rotationAngle))
              //  .padding(.bottom, screenWidth / 2)
            
        }/*.onReceive(timer) { _ in
      
            withAnimation(.easeInOut(duration: 0.5)) {
                
                scaleDimension = scaleDimension == 1.1 ? 1.0 : scaleDimension + 0.1
                rotationAngle = rotationAngle == 2 ? -2.0 : rotationAngle + 4.0
            }
           
        } */
    }
}

/*struct ClassicGameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ClassicGameSelectionView(screenWidth: UIScreen.main.bounds.width, screenHeight: UIScreen.main.bounds.height)
    }
}*/

