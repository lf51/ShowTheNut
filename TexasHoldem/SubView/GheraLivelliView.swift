//
//  GheraLevelView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 06/11/21.
//

import SwiftUI

struct GheraLivelliView: View {
    
    @ObservedObject var gl: GameLevel

    var idiomDevice:UIUserInterfaceIdiom
    var screenWidth:CGFloat

    var sizing:(fontSize:CGFloat,frameWidth:CGFloat,frameHeight:CGFloat) {
     
        if idiomDevice == .phone {
            
            let frameWidth = screenWidth * 0.30
            let frameHeight = frameWidth * 0.30

            let fontSize = frameHeight * 0.65
            
           return (fontSize,frameWidth,frameHeight)
            
            
        }
        else {
            
            let frameWidth = screenWidth * 0.25
            let frameHeight = frameWidth * 0.30
            
            let fontSize = frameHeight * 0.65
            
           return (fontSize,frameWidth,frameHeight)
          
        }
         
    }
    
    
    var body: some View {
        
        VStack {
            
            HStack{
                
                Button {
                    
                    gl.moveLevel(forward: true)
    
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.white)
                }
                .opacity(gl.lockArrow.leftA ? 0.2 : 1.0)
                .animation(Animation.linear, value: gl.lockArrow.leftA)

                Text("\(gl.level.rawValue)")
                    .bold()
                    .font(.system(size: sizing.fontSize * 0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(width:sizing.frameWidth * 0.7,height:sizing.frameHeight * 0.8)
                    .foregroundColor(Color.yellow)
                
                Button {
                    
                    gl.moveLevel(forward: false)
               
                } label: {
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.white)
                }
                .opacity(gl.lockArrow.rightA ? 0.2 : 1.0)
                .animation(Animation.linear, value: gl.lockArrow.rightA)

            }.disabled(gl.temporaryLockTransitionLevel)
        }
    }
}
