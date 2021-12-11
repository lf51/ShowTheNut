//
//  TexasHoldemApp.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

import SwiftUI
import Firebase

@main
struct TexasHoldemApp: App {
    
    @State var gameChoice:Int = 0

    init() {
        
        FirebaseApp.configure()
      //  UserDefaults.standard.set(0, forKey: "roundTB")
    }
        
    var body: some Scene {
        
        WindowGroup {

            if gameChoice == 0 {ContentView(gameChoice: $gameChoice)}
            
            else if gameChoice == 1 {ClassicGameView(exit: $gameChoice).transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 1.0)))}
            
            else if gameChoice == 2 {TimeBankView(exit: $gameChoice).transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 1.0)))}

        }
    }
}


