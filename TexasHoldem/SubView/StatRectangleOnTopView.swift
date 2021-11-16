//
//  StatRectangleOnTopView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct StatRectangleOnTopView: View {
    
    var idiomDevice:UIUserInterfaceIdiom
    
    var screenWidth:Double
    var rectangleHeight:Double
    
    var textA:String
    var textB:Float
    
    var specifier:String
    var color: Color
    
    var objectSize: (fontSizeA:Double, fontSizeB:Double, screenPartition:Double) {
        
        if idiomDevice == .phone {
            
        return ((screenWidth * 0.038),(screenWidth * 0.036),(screenWidth / 5))
            
        } else {
            
            return ((screenWidth * 0.032),(screenWidth * 0.03),(screenWidth / 6))
        }
        
    }
    
    var body: some View {
        
        VStack{

            Text(textA)
                .font(.system(size: objectSize.fontSizeA, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.top)
     
            Text("\(textB,specifier: "\(specifier)")")
                .bold()
                .font(.system(size: objectSize.fontSizeB))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .foregroundColor(color) 
                .offset(y:3.0)
                //.padding(.top)
            
        }
       // .clipped()
        .frame(width: objectSize.screenPartition, height: rectangleHeight, alignment: .center)
        .background(RoundedRectangle(cornerRadius: (screenWidth * 0.01)).foregroundColor(.gray).opacity(0.2))
       .ignoresSafeArea()
    }
}
