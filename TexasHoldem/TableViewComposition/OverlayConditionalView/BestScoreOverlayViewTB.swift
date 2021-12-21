//
//  FinalResultOverlayView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 21/10/21.
//

import SwiftUI

struct BestScoreOverlayViewTB: View {
    
    @ObservedObject var vm:AlgoritmoGioco
    @ObservedObject var ga:GameAction
  //  @ObservedObject var gl:GameLevel
    
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
            
            let fontSizePlayerWin = frameHeight * 0.075
            let fontSizePlayAgain = frameHeight * 0.065
            
            let lineSpacing = frameHeight * 0.025
            let cornerRadiusPlayAgain = frameHeight * 0.0125
            
            
            return(cornerRadiusExternal,frameHeight,offsetFrame,fontSizePlayAgain,cornerRadiusPlayAgain,fontSizePlayerWin,lineSpacing)
        }
        
        
    }
    
    
    var body: some View {
        
        VStack {
        
                ZStack{
                
                Color.black.opacity(0.7)
                    .blur(radius: 30.0, opaque: false)
                    .padding()
                    .cornerRadius(sizing.cornerRadiusExternal)
          
                VStack {
                 
                   VStack(spacing:sizing.lineSpacing) {
                       Text("Get The Nut - TB\(Int(ga.tbGameLevel.rawValue))'")
                           .font(.system(size: sizing.fontSizePlayerWin * 1.1, weight: .bold, design: .monospaced))
                      //  Text("\(ga.hands,specifier: "%.0f")").foregroundColor(Color.purple)
                       // Text("Best Streak:")
                       // Text("\(ga.winSeries, specifier: "%.0f") da modificare").foregroundColor(Color.purple)
                        
                        // Nut Hand
                        
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .padding(.vertical)
                    
                  /*  ZStack {
 
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
            
                    }*/
                    
                    Spacer()
                    
                   // if vm.playerWin {
                       
                        Text("MATCH SCORE").font(.system(size: sizing.fontSizePlayerWin, weight: .bold, design: .monospaced)).foregroundColor(Color.green)
                      
                        Text("\(ga.bankroll,specifier:"%.2f")")
                    
                 //   Spacer()
                    
                    Text("BEST SCORE").font(.system(size: sizing.fontSizePlayerWin, weight: .bold, design: .monospaced)).foregroundColor(Color.red).padding(.top)
                    
                        Text("\(ga.rebuyCount,specifier:"%.2f")") // nel rebuyCount è stoccato il best Score
                    
                    
                    // }
                    
                    
                  /*  else {
                        Text("PLAYER LOSES").font(.system(size: sizing.fontSizePlayerWin, weight: .bold, design: .monospaced)).foregroundColor(Color.red) } */
          
                  //  HStack {
                        
                     //   Text(vm.playerWin ? "+" : "-").bold().font(.system(size: sizing.fontSizePlayerWin)).foregroundColor(vm.playerWin ? Color.green : Color.red)
             
                      //  Text("\(ga.bankroll,specifier:"%.2f")")
                       
                  //  }//.padding(.top,1.0)
                    
                     Spacer()
                    
                    Button {
                        print("Numero di mani giocate: \(ga.handsTime.count) e array di tempi:\(ga.handsTime)")
                        vm.stepCount = 0
                        ga.saveScores()
                        ga.resetForNewGame()
                      //  gl.temporaryLockTransitionLevel = false
                        
                    } label: {
                        Text("Save & Play Again")
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
                
                
           // }
        }
        
    }
}


