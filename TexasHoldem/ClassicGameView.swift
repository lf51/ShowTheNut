//
//  TableView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

// proporzione altezza/base carte da gioco 1,4

import SwiftUI
import GameKit

/*
 1. Modificare la betting:
 
    • Pre-Flop --> Apertura Invariato
    • Flop --> bet fixed limited -> Due opziotni x5 o x3 o check
    • Turn --> bet fixed limited (se non si è puntato al flop)-> x2 / if pick x0.5 / o check
    • River --> Invariato
 
 Win rate alla pari, in caso di all-in pre flop paga 1.5 o 2.0
 
 √ ALL DONE
 */

struct ClassicGameView: View {
    
    @StateObject var ga: GameAction = GameAction()
    @StateObject var vm: AlgoritmoGioco = AlgoritmoGioco()
    @StateObject var gl: GameLevel = GameLevel()
    
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = (UIScreen.main.bounds.width * 0.70)
  
    var idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var areFichesDisabled:Bool {
        
        if ga.isPlayerInAllIn {return true}
        else if ga.isBetLocked {return true}
        else if vm.stepCount == 2 || vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false} else {return true }
    }
    
    @State private var showRules:Bool = false
    @Binding var exit:Int
    
    var body: some View {
        
        ZStack {
            
           // Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)).ignoresSafeArea()
           // Color(red: 0, green: 0.5603182912, blue: 0)
            Color(gl.tableColor)
                .ignoresSafeArea()
            
           /* Image("logo")
                     .resizable()
                     .scaledToFit()
                     .frame(width: screenWidth * 0.20, height: screenWidth * 0.20, alignment: .center)
                     .opacity(0.05) */
            
            VStack {
                
                ScoreView(ga:ga, gl: gl)
                
                Spacer()
            }
                    
            VStack {
                
                BoardView(vm: vm)
                    .padding(.top,(screenHeight * 0.08))
                
                if idiomDevice == .phone {
                
                    PotOnPhoneView(ga:ga, gl: gl,idiomDevice: idiomDevice,screenWidth: screenWidth)
                        .padding(.top,(screenHeight * 0.015))
                        //.overlay(Text("step: \(vm.stepCount)").padding(.top,80))
                       
                }
                
                Spacer()
            }
                
            VStack {
                
                if vm.showStudCards {
                
                    AllCardsAvaible(vm: vm)
                        .transition(AnyTransition.opacity.animation(Animation.spring()))
                                    
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
                    
                    if idiomDevice == .pad {
                        
                        BettingConsolleOnPadView(screenWidth: screenWidth, vm:vm,ga:ga, gl: gl, areFichesDisabled: areFichesDisabled)
                            .offset(x:(screenWidth/2.3))
                            .disabled(areFichesDisabled)
                        
                        GheraLivelliView(gl:gl,idiomDevice: idiomDevice,screenWidth: screenWidth)
                            .opacity(gl.temporaryLockTransitionLevel ? 0.5 : 1.0)
                            .offset(x:-(screenWidth/2.3),y: (screenWidth * 0.30) * 0.2)
                           // .padding(.bottom,(screenWidth * 0.30) * 0.2)
                      
                    } else if idiomDevice == .phone {
                        
                        BettingConsolleOnPhoneView(screenWidth: screenWidth, vm: vm, ga: ga, gl: gl, areFichesDisabled: areFichesDisabled)
                            .offset(y:-(screenHeight * 0.12))
                            .disabled(areFichesDisabled)
                        
                        GheraLivelliView(gl: gl, idiomDevice: idiomDevice,screenWidth:screenWidth)
                            .opacity(gl.temporaryLockTransitionLevel ? 0.5 : 1.0)
                            .offset(x:(screenWidth/2.3))
                            .padding(.bottom,(screenWidth * 0.30) * 0.2)
                    }
       
                    SideMenuButtonsView(screenWidth:screenWidth,idiomDevice: idiomDevice, showRules: $showRules)
                        .offset(x:-(screenWidth/2.3))
                    
               
                }
       
                ButtonConsolleView(vm: vm, ga: ga, gl: gl, exit: $exit)
                
            }
          
        }.onChange(of: vm.stepCount == 9) { step in
            
            if step {
                ga.resultAttribution(playerWin: vm.playerWin)
                SoundManager.instance.playSound(sound: vm.playerWin ? .success : .lose)
                print("------stepCount---------:\(vm.stepCount)")
                
                // leaderBoard Configuration - Salvataggio score
                
             /*   GKLeaderboard.submitScore(ga.score, context: 1, player: GKLocalPlayer.local, leaderboardIDs: ["001_bankroll"]) { error in
                    
                    guard error != nil else {
                        print(error.debugDescription.description)
                        return }
                } */
       
                // end leaderBoard Configuration
                
            } else {print("------stepCount with No Attribution---------:\(vm.stepCount)")}
    
        }
        .onChange(of: ga.bankroll, perform: { newValue in
           
            if vm.stepCount == 0 {
                
                if GameAction.localPlayerAuth {
                    
                gl.loadAchievementDone() 
                
            }
                gl.unlockLevel(bankroll: newValue, sitHighestTable: true, playerAuth: GameAction.localPlayerAuth) // questa chiamata avviene in apertura, in seguito infatti il cambio nel valore del bankroll avviene in step 9. Le chiamate seguenti sono gestite dal prox onChange, poichè dobbiamo disattivare il sit sul tavolo più alto in automatico
            }

        })// questo metodo viene chiamato in apertura, non appena viene aggiornato il bankroll dalla leaderboard. Porta il giocatore direttamente al tavolo più alto disponibile
        
        .onChange(of: ga.hands, perform: { _ in
            
            if vm.stepCount != 0 {
                gl.unlockLevel(bankroll: ga.bankroll, sitHighestTable: false, playerAuth: GameAction.localPlayerAuth)
            }
            
        }) // Quando termina il round, cambia il conto delle mani, viene chiamato questo metodo che aggiorna i livelli. Comprende dove far sedere il giocatore in base al livello precedentemente scelto dal giocatore.
        
       /* .onDisappear(perform: {
            ga.saveScoreOnFirebase()
            print("ClassicGameView disappeared")
        })*/
        
        .overlay(
 
            VStack {
                
                if ga.rebuyAvaible {BankRollOverlayView(ga:ga) }
    
                else if showRules {
                         
                    RulesOverlayView(idiomDevice:idiomDevice,screenWidth:screenWidth, dismiss: $showRules) }
                
                else if ga.isLoading {CustomLoadingView() }
                
                    FinalResultOverlayView(vm:vm,ga:ga, gl: gl,idiomDevice: idiomDevice)
                
            }
       
        )
    }
}

struct ClassicGameView_Previews: PreviewProvider {
    static var previews: some View {
        ClassicGameView(exit: .constant(1))

    }
}




