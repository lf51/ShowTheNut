//
//  FinalResultOverlayView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 21/10/21.
//

import SwiftUI

struct FinalResultOverlayViewTB: View {
    
    @ObservedObject var vm:AlgoritmoGioco
    @ObservedObject var ga:GameAction
   // @ObservedObject var gl:GameLevel
    
    var cardWidth = UIScreen.main.bounds.width * 0.16
    var idiomDevice:UIUserInterfaceIdiom

    var sizing:(cornerRadiusExternal:CGFloat,frameHeight:CGFloat,offsetFrame:CGFloat,fontSizePlayAgain:CGFloat,cornerRadiusPlayAgain:CGFloat,fontSizePlayerWin:CGFloat,lineSpacing:CGFloat) {
        
        if idiomDevice == .phone {
    
            let frameHeight = cardWidth * 6
            let offsetFrame = -(frameHeight / 8)
            let cornerRadiusExternal = frameHeight * 0.045
            
            let fontSizePlayerWin = frameHeight * 0.065
            let fontSizePlayAgain = frameHeight * 0.050
            
            let lineSpacing = frameHeight * 0.025
            let cornerRadiusPlayAgain = frameHeight * 0.0125
        
            return(cornerRadiusExternal,frameHeight,offsetFrame,fontSizePlayAgain,cornerRadiusPlayAgain,fontSizePlayerWin,lineSpacing)
        }
        else {
     
            let frameHeight = cardWidth * 3.6
            let offsetFrame = -(frameHeight / 20)
            let cornerRadiusExternal = frameHeight * 0.045
            
            let fontSizePlayerWin = frameHeight * 0.065
            let fontSizePlayAgain = frameHeight * 0.055
            
            let lineSpacing = frameHeight * 0.025
            let cornerRadiusPlayAgain = frameHeight * 0.0125
            
            
            return(cornerRadiusExternal,frameHeight,offsetFrame,fontSizePlayAgain,cornerRadiusPlayAgain,fontSizePlayerWin,lineSpacing)
        }
        
        
    }
    
    
    var body: some View {
        
        VStack {
            
            if vm.stepCount == 9 {
                
                ZStack{
                
                Color.black.opacity(0.7)
                    .blur(radius: 30.0, opaque: false)
                    .padding()
                    .cornerRadius(sizing.cornerRadiusExternal)
          
                VStack {
                 
                    VStack(spacing:sizing.lineSpacing) {
                        Text("Highest Combination:")
                        Text(vm.highestCombinationString).foregroundColor(Color.purple)
                        Text("Nut Hand:") // Nut Hand
                            
                    }
                    .minimumScaleFactor(0.1)
                    .padding(.bottom)
                    
                    ZStack {
 
                       // if !vm.nutsCards.isEmpty && vm.nutsCards.count <= 2 { // condizione Rivedibile
                            
                            HStack {

                                Group {
                                    Image(vm.nutsCards[0])
                                        .resizable()
                                    Image(vm.nutsCards[1])
                                        .resizable()
                                }
                               
                                .scaledToFit()
                                .frame(width:cardWidth, height: cardWidth * 1.4)
                                .cornerRadius(cardWidth / 14)
                                .shadow(radius: cardWidth / 14)
     
                            }
                  
                      //  } else {
                         
                        if vm.nutsCards.filter({$0 == "retroCarta2"}).count == 2 {
                           
                            Text("Play The Board")
                                .foregroundColor(Color.yellow)
                               // .padding(.top)
                            
                        }
                            
                            
                     //   }
            
                    }
                    
                    Spacer()
                    
                    if vm.playerWin {
                       
                        Text("PLAYER WIN").font(.system(size: sizing.fontSizePlayerWin, weight: .bold, design: .monospaced)).foregroundColor(Color.green) }
                    else {
                        Text("PLAYER LOSES").font(.system(size: sizing.fontSizePlayerWin, weight: .bold, design: .monospaced)).foregroundColor(Color.red) }
          
                    HStack {
                        
                        Text(vm.playerWin ? "+" : " ").bold().font(.system(size: sizing.fontSizePlayerWin)).foregroundColor(vm.playerWin ? Color.green : Color.red)
             
                        Text("\(ga.moneyWinOrLoose,specifier:"%.2f")") // corrisponde allo Score nel TimeBank
                       
                    }//.padding(.top,1.0)
                    
                     Spacer()
                    
                    Button {
                        
                        vm.stepCount = 0
                      //  gl.temporaryLockTransitionLevel = false
                        
                    } label: {
                        Text("Continue")
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(sizing.cornerRadiusPlayAgain)
                    }

                }
                .font(.system(size: sizing.fontSizePlayAgain, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white)
                .padding()
                
            }
            .frame(maxWidth:.infinity)
            .frame(height: sizing.frameHeight)
            .offset(y: sizing.offsetFrame)
            .transition(AnyTransition.opacity.animation(Animation.default))
                
                
            }
        }
        
    }
}


