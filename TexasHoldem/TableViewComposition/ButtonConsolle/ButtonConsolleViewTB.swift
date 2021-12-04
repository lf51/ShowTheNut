//
//  ButtonConsolleViewTB.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import SwiftUI

struct ButtonConsolleViewTB: View {
    
    @ObservedObject var vm:AlgoritmoGioco
    @ObservedObject var ga:GameAction
   // @ObservedObject var gl:GameLevel
    
    var screenWidth = (UIScreen.main.bounds.width * 0.85)
    let idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var buttonSize: (frameHeight:Double,fontSize:Double) {
  
        if idiomDevice == .phone {return ((screenWidth * 0.15),((screenWidth / 4) * 0.20))}
        else {return ((screenWidth * 0.12),((screenWidth / 4) * 0.15))}
        
    }
  
  /* var buttonColor: Color {
        
        if ga.countDown > 180 * 0.5 {return .green }
        else if ga.countDown > 180 * 0.25 {return .yellow }
        else {return .red}
        
    } */
    
    @State var buttonColor: CGFloat = 1.0
    
    @State var startCount = false
    
    var body: some View {
        
        HStack {
            
           // if vm.stepCount == 0 {
               
                Button(action: {
                   // SoundManager.instance.playSound(sound: .cardsShuffle)
                    vm.shuffleUp()
                    ga.storedCountDown = ga.countDown // salviamo il valore del countDown prima che inizi a scorrere
                    ga.showAccessPoint(isActive: false)
                   // gl.temporaryLockTransitionLevel = true
                    startCount = true
                   // ga.cleanOrFoldAction()
                },
                       label: {
                    
                    Circle()
                        .frame(height: buttonSize.frameHeight * 1.5)
                        .foregroundColor(vm.stepCount == 0 ? Color.blue : Color(red: (1 - buttonColor), green: buttonColor, blue: 0.0))
                        .shadow(color: Color.black, radius: 5.0)
                        .overlay(
                        
                            Text(vm.stepCount == 0 ? "Deal" : "\(ga.countDown,specifier: "%.2f")")
                                .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.white)
                        
                        )
                      
                }).disabled(vm.stepCount != 0)
     
        }.onReceive(ga.timer) { _ in
           
            if vm.stepCount == 2 || vm.stepCount == 4 {
                
                if ga.countDown > 0 {
                    
                    ga.countDown -= 0.01
                    buttonColor -= 0.000166 // == 1 / (60 sec * 100)
                }
                else  {
                    vm.areCardsUnpickable = true
                    ga.isGameEnded = true 
                }
                
               
                
            }
            
        }
    }
}

/*struct ButtonConsolleViewTB_Previews: PreviewProvider {
    static var previews: some View {
        ButtonConsolleViewTB()
    }
}
*/
