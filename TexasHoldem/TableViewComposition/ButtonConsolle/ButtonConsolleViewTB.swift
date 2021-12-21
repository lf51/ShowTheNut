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
    
    @State var buttonColor: Float = 1.0
    @State var startCount = false
    
   // var isPremiumCheck:Bool { UserDefaults.standard.integer(forKey: "roundTB") == 5} // Serviva a bloccare il pulsante qualore durante la partita scattava il 5° round. Si può riciclare per far scattare l'ads
    
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
                        .foregroundColor(vm.stepCount == 0 ? Color.blue : Color(red: (1 - Double(buttonColor)), green: Double(buttonColor), blue: 0.0))
                        //.shadow(color: Color.black, radius: /*isPremiumCheck ||*/ vm.stepCount != 0 ? 0.0 : 5.0)
                        .shadow(color: Color.black, radius: vm.stepCount != 0 ? 0.0 : 5.0)
                        .overlay(
                        
                            Text(vm.stepCount == 0 ? "Deal" : "\(ga.countDown,specifier: "%.2f")")
                                .font(Font.system(size: buttonSize.fontSize, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.white)
                        
                        )
                       // .opacity(isPremiumCheck ? 0.6 : 1.0)
                       
                      
                    
                    
                }).disabled(vm.stepCount != 0)
               // .disabled(vm.stepCount != 0 || isPremiumCheck)
     
        }.onReceive(ga.timer) { _ in
           
            if vm.stepCount == 2 || vm.stepCount == 4 {
                
                if ga.countDown > 0 {
                    
                    ga.countDown -= ga.timerSection
                    buttonColor -= (1 / ((ga.tbGameLevel.rawValue * 100) * 0.01/ga.timerSection))
                }
                else  {
                    vm.areCardsUnpickable = true
                    ga.isGameEnded = true
                    buttonColor = 1.0
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
