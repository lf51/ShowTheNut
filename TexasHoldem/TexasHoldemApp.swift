//
//  TexasHoldemApp.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

import SwiftUI
import Firebase
/*
 
 - Simulare l'ottenimento degli Achievment. Rendiamo il valore accessibile e simuliamo - √Fatto
 - Creare Achievmente della vittoria ultimo livello - √Fatto
 - Creare immagini achievment livello - √Fatto
 - Gestire dati di ogni livello su Firebase - √Fatto
 - Connettere tutto con Firebase - Classifica unica su GameKit - √Fatto
 
 */

@main
struct TexasHoldemApp: App {
    
    @StateObject var apGK: AuthPlayerGK = AuthPlayerGK.instance
    
    @State var gameChoice:Int = 0
    @State var tbGameLevel:GameLevelTB = .one
    
    init() {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        db.app.isDataCollectionDefaultEnabled = false
        print("isDataCollectionEnabledDefault:\(db.app.isDataCollectionDefaultEnabled.description)")
        
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            if gameChoice == 0 {
                ContentView(apGK: apGK, gameChoice: $gameChoice, tbGameLevel:$tbGameLevel)
                    .overlay(
                        VStack {
                            
                            if apGK.isLoading {CustomLoadingView()}
                            
                            else if apGK.showError ?? false {ErrorOverlayViewTB(apGK:apGK) }
                                                        
                        }
                    )
            }

            else if gameChoice == 2 {
               /* TimeBankView(tbGameLevel: tbGameLevel, exit: $gameChoice, localPlayerAuth: apGK.localPlayerAuth,authFailed: apGK.authFailed)*/
                TimeBankView(ga: GameAction(tbGameLevel: tbGameLevel, localPlayerAuth: apGK.localPlayerAuth), exit: $gameChoice)
                .transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 1.0)))}

        }
    }
}


