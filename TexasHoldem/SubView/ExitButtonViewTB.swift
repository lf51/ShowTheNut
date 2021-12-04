//
//  ExitButtonView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/11/21.
//

import SwiftUI

struct ExitButtonViewTB: View {
    
    var screenWidth:CGFloat
    
    var fontSize:CGFloat {
        
        let frameWidth = screenWidth * 0.30
        let frameHeight = frameWidth * 0.30
        let fontSize = frameHeight * 0.65
        return fontSize
    }
    
    var body: some View {
    
        Image(systemName: "eject")
            .font(Font.system(size: fontSize, weight: .bold, design: .monospaced))
            .foregroundColor(Color.red)
           // .padding()
          //  .background(Color.red)
           // .cornerRadius(10.0)
    }
}

struct ExitButtonViewTB_Previews: PreviewProvider {
    static var previews: some View {
        ExitButtonViewTB(screenWidth: UIScreen.main.bounds.width)
    }
}
