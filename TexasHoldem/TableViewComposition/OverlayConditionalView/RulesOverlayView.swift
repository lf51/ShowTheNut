//
//  RulesOverlayView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 31/10/21.
//

import SwiftUI

struct RulesOverlayView: View {
    
    var idiomDevice:UIUserInterfaceIdiom
    var screenWidth:Double
    @Binding var dismiss:Bool
    
    var fontSize:Double {
        
        if idiomDevice == .phone {
            
        return (screenWidth * 0.05)
            
        } else {
            
            return (screenWidth * 0.042)
        }
        
    }
    
   // var avaibleLanguage = ["it-IT", "en", "fr-FR", "zh-Hans-US"]
    
    var languages:[String] {
        
        let languageCFArray = CFLocaleCopyPreferredLanguages()
        
       return languageCFArray as! [String]
        
    }
    
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.7)//.ignoresSafeArea()
                .blur(radius: 30.0, opaque: false)
                .padding(.horizontal)
                .cornerRadius(30.0)
           
            VStack {
                
                if languages[0].contains("it") {ItalianRulesView(fontSize: fontSize)}
                else if languages[0].contains("fr") {FrenchRulesView()}
                else if languages[0].contains("zh") {ChinaRulesView()}
                else if languages[0].contains("es") {SpanishRulesView()}
                else {EnglishRulesView(fontSize: fontSize)}
              
                Button {
                    
                    self.dismiss.toggle()
                    
                } label: {
                    Text("Dismiss")
                        .shadow(color: Color.black, radius: 5.0, x: 0.0, y: 0.0)
                        .font(.system(size: fontSize * 1.2, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.red)
                        .padding(.bottom)
                        .padding()
                    
                }
                
            }
            
            
        }
    }
}


