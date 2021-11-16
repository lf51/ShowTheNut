//
//  TableView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

// proporzione altezza/base carte da gioco 1,4



import SwiftUI
import GameKit

struct MultiPlayer: View {
    
    @StateObject var ga: GameAction = GameAction()
    @StateObject var vm: AlgoritmoGioco = AlgoritmoGioco()
    
    // configurazione livelli Table
    
    @StateObject var gl: GameLevel = GameLevel()

    // end livello Table
    
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = (UIScreen.main.bounds.width * 0.70)
  
    var idiomDevice = UIDevice.current.userInterfaceIdiom
    
    var areFichesDisabled:Bool {
        
        if ga.isPayOutAmplificatorLocked {return true}
        
        else if vm.stepCount == 2 || vm.stepCount == 4 || vm.stepCount == 6 || vm.stepCount == 7 {return false} else {return true }
    }
    
    @State private var showRules:Bool = false
 
    
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
                
            }.hidden() //
                    
            VStack {
                
                BoardView(vm: vm)
                    .padding(.top,(screenHeight * 0.08))
                
                if idiomDevice == .phone {
                
                    PotOnPhoneView(ga:ga, gl: gl,idiomDevice: idiomDevice,screenWidth: screenWidth)
                        .padding(.top,(screenHeight * 0.015))
                        .overlay(Text("step: \(vm.stepCount)").padding(.top,80))
                        .hidden() //
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
                        
                        BettingConsolleOnPadView(vm:vm,ga:ga, gl: gl, areFichesDisabled: areFichesDisabled)
                            .offset(x:(screenWidth/2.3))
                            .disabled(areFichesDisabled)
                      
                    } else if idiomDevice == .phone {
                        
                        BettingConsolleOnPhoneView(vm: vm, ga: ga, gl: gl, areFichesDisabled: areFichesDisabled)
                            .offset(y:-(screenHeight * 0.12))
                            .disabled(areFichesDisabled)
                        
                        GheraLivelliView(gl: gl, idiomDevice: idiomDevice,screenWidth:screenWidth)
                            .opacity(gl.temporaryLockTransitionLevel ? 0.5 : 1.0)
                            .offset(x:(screenWidth/2.3))
                    }
       
                    SideMenuButtonsView(gl: gl, screenWidth:screenWidth,idiomDevice: idiomDevice, showRules: $showRules)
                        .offset(x:-(screenWidth/2.3))
               
                }.hidden()
       
                ButtonConsolleViewMP(vm: vm, ga: ga, gl: gl)
                
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
                
                if ga.localPlayerAuth { gl.loadAchievementDone() }
                gl.unlockLevel(bankroll: newValue, sitHighestTable: true, playerAuth: ga.localPlayerAuth)}

        })// questo metodo viene chiamato in apertura, non appena viene aggiornato il bankroll dalla leaderboard. Porta il giocatore direttamente al tavolo più alto disponibile
        
        .onChange(of: ga.hands, perform: { _ in
            
            gl.unlockLevel(bankroll: ga.bankroll, sitHighestTable: false, playerAuth: ga.localPlayerAuth)
        }) // Quando termina il round, cambia il conto delle mani, viene chiamato questo metodo che aggiorna i livelli. Comprende dove far sedere il giocatore in base al livello precedentemente scelto dal giocatore.
        
        .overlay(
 
            VStack {
                
                if ga.rebuyAvaible {BankRollOverlayView(ga:ga) }
    
                else if showRules {
                         
                    RulesOverlayView(idiomDevice:idiomDevice,screenWidth:screenWidth, dismiss: $showRules) }
                
                    FinalResultOverlayView(vm:vm,ga:ga, gl: gl,idiomDevice: idiomDevice)
                
            }
       
        )
    }
}

/*struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()

    }
} */




