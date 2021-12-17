//
//  TexasHoldemApp.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 24/09/21.
//

import SwiftUI


@main
struct TexasHoldemApp: App {
    
    @State var gameChoice:Int = 0
    @State var inSecond:InSecondTB = .level_1
        
    var body: some Scene {
        
        WindowGroup {

            if gameChoice == 0 {ContentView(gameChoice: $gameChoice,inSecond:$inSecond)}
            
           /* else if gameChoice == 1 {
                
                EmptyView()
                .transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 1.0)))} */
            
            else if gameChoice == 2 {TimeBankView(inSecond: inSecond, exit: $gameChoice).transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 1.0)))}

        }
    }
}


