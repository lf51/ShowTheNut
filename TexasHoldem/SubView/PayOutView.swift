//
//  PayOutView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 28/10/21.
//

import SwiftUI

struct PayOutView: View {
    
    @ObservedObject var ga:GameAction
    var idiomDevice:UIUserInterfaceIdiom
    
    var screenWidth:Double
    var rectangleHeight:Double
    
    var body: some View {
         
            if idiomDevice == .phone {
                
                Text("\(ga.payOutRate, specifier: "%.1f")x")
                     .font(.system(size:(screenWidth * 0.05), weight: .bold, design: .monospaced))
                     .frame(width: (screenWidth / 5.0), height: (rectangleHeight / 3.5), alignment: .center)
                     .foregroundColor(Color.white)
                     .background(Color.blue)
                     .cornerRadius(screenWidth * 0.02)

                
            } else {
                
                Text("\(ga.payOutRate, specifier: "%.1f")x")
                     .font(.system(size:(screenWidth * 0.02), weight: .bold, design: .monospaced))
                     .frame(width: (screenWidth / 14), height: (rectangleHeight / 2.5), alignment: .center)
                     .foregroundColor(Color.white)
                     .background(Color.blue)
                     .cornerRadius(screenWidth * 0.01)
            }
   
    }
}
