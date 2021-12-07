//
//  TimeBankGame.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

/* Creare un opzione per cui al verificarsi di una qualche situazione si attiva una sorta di FantasyLand dove i punti valgono doppio tipo */

import SwiftUI

struct TimeBankView: View {
    
    @StateObject var ga: GameAction = GameActionTB()
    @StateObject var vm: AlgoritmoGioco = AlgoritmoTB()
  //  @StateObject var gl: GameLevel = GameLevel()

    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = (UIScreen.main.bounds.width * 0.70)
  
    var idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var areFichesDisabled:Bool {
        
        if ga.isPlayerInAllIn {return true}
        
        else if vm.stepCount == 2 || vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false} else {return true }
    }
    
    @State private var showRules:Bool = false
    @Binding var exit:Int 
    
    var body: some View {
        
        ZStack {
        
            
           // Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)).ignoresSafeArea()
           Color(red: 0, green: 0.5603182912, blue: 0)
           // Color(gl.tableColor)
                .ignoresSafeArea()
            
           /* Image("logo")
                     .resizable()
                     .scaledToFit()
                     .frame(width: screenWidth * 0.20, height: screenWidth * 0.20, alignment: .center)
                     .opacity(0.05) */
            
            VStack {
                
                ScoreViewTB(ga:ga)
                
                Spacer()
            }
                    
            VStack {
                
                BoardView(vm: vm)
                    .padding(.top,(screenHeight * 0.08))
                
             //   Text("\(vm.stepCount)") // da togliere
           
                Spacer()
            }
                
            VStack {
                
                
                if vm.showStudCards {
                
                    if idiomDevice == .phone {
                        
                        AllCardsAvaibleTB(vm: vm)
                            .transition(AnyTransition.opacity.animation(Animation.spring()))
                    }
                    
                    else {AllCardsAvaible(vm: vm)
                        .transition(AnyTransition.opacity.animation(Animation.spring()))} // su ipad usiamo la versione Classic in orizzontale
                                    
                } else {
                    
                    PreFlopShufflingCards(vm:vm, idiomDevice: idiomDevice)
    
                }
            }
            .padding(idiomDevice == .pad ? .bottom : .top,idiomDevice == .pad ? (screenHeight * 0.04) : (screenHeight * 0.06))

            VStack {
                
                Spacer()
     
                ZStack{
                    
                    MyCardsView(vm:vm)
                        .zIndex(1.0)
                    
                    VStack {
                        
                        SideMenuButtonsView(screenWidth:screenWidth,idiomDevice: idiomDevice, showRules: $showRules)
                            
                        Button {
                            
                            self.exit = 0
                            
                        } label: {ExitButtonViewTB(screenWidth: screenWidth).opacity(vm.stepCount != 0 ? 0.2 : 1.0)}.disabled(vm.stepCount != 0)
                        
                    }.offset(x:-(screenWidth/2.3))
                    
               
                    ButtonConsolleViewTB(vm: vm, ga: ga)
                        .offset(x:(screenWidth/2.3))
                        .padding(.bottom)
                    
                }
            }
          
        }.onChange(of: vm.stepCount == 9) { step in
            
            if step {
                
                ga.resultAttribution(playerWin: vm.playerWin, combination: vm.highestCombination!)
                
                SoundManager.instance.playSound(sound: vm.playerWin ? .success : .lose)
                print("------stepCount---------:\(vm.stepCount)")
                
            } else {print("------stepCount with No Attribution---------:\(vm.stepCount)")}
    
        }.onChange(of: ga.isGameEnded, perform: { isGameTermineted in
            
            if isGameTermineted {
                
                ga.showAccessPoint(isActive: true)
                ga.compareScore()
                
            }
        })
       /* .onChange(of: ga.bankroll, perform: { newValue in
           
            if vm.stepCount == 0 {
                
                if ga.localPlayerAuth { gl.loadAchievementDone() }
                gl.unlockLevel(bankroll: newValue, sitHighestTable: true, playerAuth: ga.localPlayerAuth)}

        })*/ // questo metodo viene chiamato in apertura, non appena viene aggiornato il bankroll dalla leaderboard. Porta il giocatore direttamente al tavolo più alto disponibile
        
      /*  .onChange(of: ga.hands, perform: { _ in
            
            gl.unlockLevel(bankroll: ga.bankroll, sitHighestTable: false, playerAuth: ga.localPlayerAuth)
        }) */ // Quando termina il round, cambia il conto delle mani, viene chiamato questo metodo che aggiorna i livelli. Comprende dove far sedere il giocatore in base al livello precedentemente scelto dal giocatore.
        
        .overlay(
 
            VStack {
           
                if ga.isGameEnded {BestScoreOverlayViewTB(vm: vm, ga: ga, idiomDevice: idiomDevice)}
    
                else if showRules {
                         
                    RulesOverlayViewTB(idiomDevice:idiomDevice,screenWidth:screenWidth, dismiss: $showRules) }
                
                else if ga.isLoading {CustomLoadingView() }
                // if vm.stepCount == 9
                    FinalResultOverlayViewTB(vm:vm,ga:ga,idiomDevice: idiomDevice)
                //
            }
       
        )
    }
}

/*
struct TimeBankGame_Previews: PreviewProvider {
    static var previews: some View {
        TimeBankView()
    }
} */
