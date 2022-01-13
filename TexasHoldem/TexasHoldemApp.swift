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
 
 
 --- Abbiamo cambiato il bundleID da TexasHoldem a ShowTheNut, occorre cambiarlo anche su Firebase e sostituire il googlePlist. Al momento il firebase funziona con la versione precedente che ho installata sul telefono --- √ RISOLTO --> sullo stesso progetto abbiamo caricato anche quest'altro bundle
 
 --- Dopo diversi tentativi abbandoniamo la pubblicazione su APPStore perchè nonostante il bundle nuovo e tutta la procedura da zero sostengono che trattasi di gioco d'azzardo simulato. Possiamo provare a tradurla per Android, o sfruttare l'algoritmo per creare un altro gioco ---
 
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


