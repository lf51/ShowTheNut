//
//  SideRulesButton.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct SideMenuButtonsView: View {
    
   // @ObservedObject var gl: GameLevel
    
    var screenWidth:CGFloat
    var idiomDevice:UIUserInterfaceIdiom
    
    var sizing:(fontSize:CGFloat,cornerRadius:CGFloat,frameWidth:CGFloat,frameHeight:CGFloat,paddingVerical:CGFloat) {
     
        if idiomDevice == .phone {
            
            let frameWidth = screenWidth * 0.30
            let frameHeight = frameWidth * 0.30
            
            //let fontSize = frameHeight * 0.45
            let fontSize = frameHeight * 0.65
            let cornerRadius = frameWidth * 0.05
            let paddingVertical = frameWidth * 0.20
            
           return (fontSize,cornerRadius,frameWidth,frameHeight,paddingVertical)
            
            
        }
        else {
            
            let frameWidth = screenWidth * 0.25
            let frameHeight = frameWidth * 0.30
            
            //let fontSize = frameHeight * 0.45
            let fontSize = frameHeight * 0.65
            let cornerRadius = frameWidth * 0.05
            let paddingVertical = frameWidth * 0.20
            
           return (fontSize,cornerRadius,frameWidth,frameHeight,paddingVertical)
          
        }
         
    }
    
    @Binding var showRules:Bool
    
    var body: some View {
        
        VStack {
            
            Button {
                showRules.toggle()
            } label: {
                
                HStack{
                    
                    Image(systemName: "info.circle")
                        .font(.system(size: sizing.fontSize))
                        
                    
                    Text("Rules")
                        .font(.system(size: sizing.fontSize, weight: .bold, design: .monospaced))
                       // .background(RoundedRectangle(cornerRadius: sizing.cornerRadius).frame(width:sizing.frameWidth,height:sizing.frameHeight).foregroundColor(Color.clear))
                        
                }.accentColor(Color.white)
                    .opacity(0.5)
                    .padding(.bottom, sizing.paddingVerical * 0.7)
                
                
            }
 
      /*   if idiomDevice == .pad {
                
             Text("hidden text just to have a space").hidden()
                 .padding(.bottom,sizing.paddingVerical * 0.7)
             
             /*   GheraLivelliView(gl:gl,idiomDevice: idiomDevice,screenWidth: screenWidth)
                    .opacity(gl.temporaryLockTransitionLevel ? 0.5 : 1.0)
                    .padding(.bottom,sizing.paddingVerical * 0.7)*/
                
            } */
           
               // .padding(.vertical,sizing.paddingVerical * 0.9)
            
          /*  Button {
                
            } label: {
                Text("LeaderBoard")
                    .font(.system(size: sizing.fontSize, weight: .bold, design: .monospaced))
                    .background(RoundedRectangle(cornerRadius: sizing.cornerRadius).frame(width:sizing.frameWidth,height:sizing.frameHeight).foregroundColor(Color.orange))
                    .accentColor(Color.white)
                    .padding(.vertical,sizing.paddingVerical)
            } */
            
        }
    }
}


