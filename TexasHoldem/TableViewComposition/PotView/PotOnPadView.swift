//
//  PotOnPadView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct PotOnPadView: View {
    
    @ObservedObject var ga:GameAction
    @ObservedObject var gl:GameLevel
    
    var idiomDevice:UIUserInterfaceIdiom
    
    var screenWidth:Double
    var rectangleHeight:Double
    
    var body: some View {
        
        HStack {
            
          //  FichesView(value: .one,screenReduction: 0.07)
            PayOutView(ga: ga,idiomDevice: idiomDevice,screenWidth: screenWidth,rectangleHeight:rectangleHeight)
                .padding(.leading)
                
            Spacer()
            Text("\(ga.pot,specifier: "%.2f")")
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .foregroundColor(Color.white)
                
            Spacer()
            
        }
        .clipped()
        .font(.system(size: (screenWidth * 0.05)))
        .frame(width: (screenWidth / 4), height: rectangleHeight, alignment: .center)
        .background(RoundedRectangle(cornerRadius: (screenWidth * 0.01)).foregroundColor(Color.white).opacity(0.1))
       // .opacity(0.8)
        .ignoresSafeArea()
    }
}
