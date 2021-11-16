//
//  PotOnPhoneView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct PotOnPhoneView:View {
    
    // Solo per iphone
    @ObservedObject var ga:GameAction
    @ObservedObject var gl:GameLevel
    var idiomDevice: UIUserInterfaceIdiom
    
   // var screenWidth:Double = UIScreen.main.bounds.width
    var screenWidth:Double
    var rectangleHeight:Double {
        
        screenWidth / 2.51618
        
    }
    
    var body: some View {
        
        HStack {
            
           // FichesView(value: .one,screenReduction: 0.12)
            PayOutView(ga: ga, idiomDevice: idiomDevice, screenWidth: screenWidth, rectangleHeight: rectangleHeight)
                .padding(.leading)
            
            Spacer()
            
            Text("\(ga.pot,specifier: "%.2f")")
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Spacer()
            
        }
        .clipped()
        .font(.system(size: (screenWidth * 0.07)))
        .frame(width: (screenWidth / 1.4), height: rectangleHeight, alignment: .center)
        .background(RoundedRectangle(cornerRadius: (screenWidth * 0.013)).foregroundColor(Color.white).opacity(0.1))
     
     //   .ignoresSafeArea()
        
        
        
    }
    

    
}
