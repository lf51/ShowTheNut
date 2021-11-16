//
//  TesterView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 01/10/21.
//

import SwiftUI

struct ChipsView: View {
    
    var cardWidth = UIScreen.main.bounds.width * 0.11
    var areFichesDisabled:Bool = false
    
    var fichesWidth: CGFloat {
        
        cardWidth * 0.60
        
    }
    
    var (sfondo,rectangles,middle,chipValue) = (Color.red,Color.yellow,Color.white,"")
    
    init(value:ChipsValue,screenReduction:Double,areFichesDisabled:Bool){
        
        cardWidth = UIScreen.main.bounds.width * screenReduction
        self.areFichesDisabled = areFichesDisabled
        
        (sfondo,rectangles,middle,chipValue) = assignColor(value: value)
        
    }
    
    func assignColor(value:ChipsValue)->(sfondo:Color,rectangles:Color,middle:Color,value:String) {
        
        switch value {
            
        case .high(let coinValue):
            
            return (Color.black,Color.blue,Color.white,coinValue == "1000" ? "1k" : coinValue)
         
        case .middle(let coinValue):
            
            return (Color.red,Color.green,Color.white,coinValue)
        
        case .big(let coinValue):
            
            return (Color.blue,Color.yellow,Color.white,coinValue)
            
        case .small(let coinValue):
            
            return (Color.black,Color.green,Color.white,coinValue == "0.50" ? "50c" : coinValue)
            
        case .c:
            
            return (Color.red,Color.clear,Color.white,"C")
            
        case .all:
            
            return (Color.blue,Color.clear,Color.white,"in")
            
        }
    }

    var body: some View {
        
         
            ZStack {
                
                ZStack {
                    
                    Circle()
                          .foregroundColor(sfondo)
                          .frame(width: fichesWidth, height: fichesWidth, alignment: .center)
                          .shadow(color: .black, radius: 1.0)
                          .zIndex(0.0)
                      
                    RoundedRectangle(cornerRadius: fichesWidth)
                          .foregroundColor(rectangles)
                          .frame(width: fichesWidth, height: (fichesWidth/4), alignment: .center)
                          .rotationEffect(Angle(degrees: 90.0))
                    
                    RoundedRectangle(cornerRadius: fichesWidth)
                          .foregroundColor(rectangles)
                          .frame(width: fichesWidth, height: (fichesWidth/4), alignment: .center)
                          .rotationEffect(Angle(degrees: 0.0))
          
                }
            
             Circle()
                    .foregroundColor(middle)
                    .frame(width: (fichesWidth*0.55), height: (fichesWidth*0.55), alignment: .center)
                    .shadow(color: .black, radius: 0.1)
                    .zIndex(1.0)
                    .overlay(
                    
                        Text("\(chipValue)")
                            .bold()
                            .foregroundColor(Color.black)
                            .opacity(areFichesDisabled ? 0.2 : 1.0)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
            
                    )
            }
    }
}
/*
struct FichesView_Previews: PreviewProvider {
    static var previews: some View {
        
        HStack{
            
            ChipsView(value: .big,screenReduction: 0.11)
            ChipsView(value: .middle,screenReduction: 0.11)
            ChipsView(value: .high,screenReduction: 0.11)
            ChipsView(value: .c,screenReduction: 0.11)
            ChipsView(value: .small,screenReduction: 0.11)
        }
        
    }
}
*/
