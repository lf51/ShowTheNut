//
//  BottonConsolleView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct ButtonConsolleView: View {
    
    @ObservedObject var vm:AlgoritmoGioco
    @ObservedObject var ga:GameAction
    @ObservedObject var gl:GameLevel
    
    var screenWidth = (UIScreen.main.bounds.width * 0.85)
    let idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var buttonSize: (frameHeight:Double,fontSize:Double) {
  
        if idiomDevice == .phone {return ((screenWidth * 0.15),((screenWidth / 4) * 0.20))}
        else {return ((screenWidth * 0.12),((screenWidth / 4) * 0.15))}
        
    }
    
    var isBetDisabled:Bool {
        
        if ga.isPayOutAmplificatorLocked {return true} // usiamo questa property bool perchè ritorna
        
       else if vm.stepCount == 2 || vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false} else {return true }
    }
    
    var areFoldDisabled:Bool {
        
        if ga.isPayOutAmplificatorLocked {return true}
        
       else if vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false } else {return true}
        
    }
    
    var areCheckDisabled:Bool {
        
       if vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false } else {return true}
        
    }
    
    var isPickDisabled:Bool {
        
        vm.stepCount != 6
    }
    
    var body: some View {
        
        HStack {
            
            if vm.stepCount == 0 {
               
                Button(action: {
                   // SoundManager.instance.playSound(sound: .cardsShuffle)
                    vm.shuffleUp()
                    ga.showAccessPoint(isActive: false)
                    gl.temporaryLockTransitionLevel = true 
                   // ga.cleanOrFoldAction()
                },
                       label: {
                    Text("Shuffle Up")
                        .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                        .frame(maxWidth: screenWidth)
                        .frame(height:buttonSize.frameHeight)
                        .background(Color.yellow)
                        .cornerRadius(screenWidth / 51.618)
                        .foregroundColor(Color.gray)
                        .opacity(ga.isPayOutAmplificatorLocked ? 0.5 : 1.0)
                    
                }).disabled(ga.isPayOutAmplificatorLocked)
   
                
            } else {
                
                Button(action: {
                    vm.cleanOrFoldAction()
                    ga.cleanOrFoldAction()
                },
                       
                       label: {
                    Text("Fold")
                        .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                        .frame(maxWidth: screenWidth / 4)
                        .frame(height:buttonSize.frameHeight)
                        .background(Color.red)
                        .cornerRadius(screenWidth / 51.618)
                        .foregroundColor(Color.white)
                        .opacity(areFoldDisabled ? 0.5 : 1.0)
                    
                }).disabled(areFoldDisabled)
       
                Button(action: {

                    vm.changingCardAvaible = true
                    vm.stepCount = 5
                    ga.isTherePayOutReduction = true 
            
                },
                       label: {
                   
                    HStack {
                        
                        Image(systemName: "arrow.2.squarepath")
                        
                        Text("Pick")
      
                    }
                    .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                        .frame(maxWidth: screenWidth / 4)
                        .frame(height:buttonSize.frameHeight)
                        .background(Color.yellow)
                        .cornerRadius(screenWidth / 51.618)
                        .foregroundColor(Color.white)
                        .opacity(isPickDisabled ? 0.5 : 1.0)
                    
                }).disabled(isPickDisabled)
                
                Button(action: {
                    SoundManager.instance.playSound(sound: .check)
                    // sul Flop
                    if vm.stepCount == 4 {vm.showTurn() }
                    // sul Turn
                    else if vm.stepCount == 6 || vm.stepCount == 7 {vm.showRiver() }
                    
                    
                }, label: {
                    Text("Check")
                        .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                        .frame(maxWidth: screenWidth / 4)
                        .frame(height:buttonSize.frameHeight)
                        .background(Color.orange)
                        .cornerRadius(screenWidth / 51.618)
                        .foregroundColor(Color.white)
                        .opacity(areCheckDisabled ? 0.5 : 1.0)
                    
                }).disabled(areCheckDisabled)
               
                
                Button(action: {
                    if ga.bet != 0 {
                        
                        ga.potComposition(stepCount: vm.stepCount)
                        // pre-flop
                        if vm.stepCount == 2 { vm.deal()}
                        // sul Flop
                        else if vm.stepCount == 4 {vm.showTurn() }
                        // sul Turn
                        else if vm.stepCount == 6 || vm.stepCount == 7 {vm.showRiver() }
                        //
                    }
                   
                },
                       
                       label: {
      
                    VStack {
                        
                        Text("Bet")
                            .padding(.top)
                        Text("\(ga.bet,specifier: "%.2f")")
                           // .minimumScaleFactor(0.7)
                            .padding(.bottom)
 
                    }
                        .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                        .frame(maxWidth: screenWidth / 4)
                        .frame(height:buttonSize.frameHeight)
                        .background(Color.green)
                        .cornerRadius(screenWidth / 51.618)
                        .foregroundColor(Color.white)
                        .opacity(isBetDisabled ? 0.5 : 1.0)
                        
                }).disabled(isBetDisabled)
               
                
                
            }
            
            
            
            
        }
    }
}
