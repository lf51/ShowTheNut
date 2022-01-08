//
//  HomeView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var apGK:AuthPlayerGK
    
    var screenWidth:CGFloat = UIScreen.main.bounds.width
    var screenHeight:CGFloat = UIScreen.main.bounds.height
    
    @Binding var gameChoice: Int
    @Binding var tbGameLevel: GameLevelTB
    
   /* var isNotPremium:Bool {
        
        UserDefaults.standard.integer(forKey: "roundTB") == 5
    } */
    
  /*  var isLevelUnlocked:(level_2:Bool,level_3:Bool,level_4:Bool) = {
        
        let userDef = UserDefaults.standard
        let l2 = userDef.bool(forKey: "isLevel2Unlock")
        let l3 = userDef.bool(forKey: "isLevel3Unlock")
        let l4 = userDef.bool(forKey: "isLevel4Unlock")
        print("inside isLevelUnlocked on ContentView")
        return(l2,l3,l4)
        
    }()// la differenza con la computed classica, è che in questa forma (con = e ()) viene eseguita una volta (il print va in stampa una volta) mentre la classica 3 volte, una per ogni valore della tupla. Questa versione -- che non so come si chiama -- sembra dunque più efficiente.
    */
    
    var body: some View {
     
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack {
                
                ZStack(alignment:.bottom) {
                    
                    ClassicGameSelectionView(screenWidth: screenWidth, screenHeight: screenHeight)
                    
                    Text("Show The Nut")
                             .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                             .foregroundColor(Color.yellow)
                             .frame(maxWidth:screenWidth)
                             .frame(height: screenWidth * 0.12, alignment: .center)
                             .padding()
                             .background(Color(CGColor(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5))
                }
                
                
             /*   Button {
                    
                    self.gameChoice = 1
                    
                } label: {
                    ClassicGameSelectionView(screenWidth: screenWidth, screenHeight: screenHeight)
                }.disabled(true) */
           
             /*   Button {
                    
                    self.gameChoice = 2
                    
                } label: {
                    TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight)
                }.disabled(isNotPremium) */
                
                
                
                HStack {
                    
                    Button {
                        
                        self.tbGameLevel = .one
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.gameChoice = 2
                            print("dentro il dispatch gameChoice")
                        } // usiamo un dispatch perchè capita a volte di uscire da un livello per entrare in un altro e il livello che viene aperto è il precedente. Proviamo con il dispatch a risolvere il problema
                        
                        
                    } label: {
                        
                        TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight, tbGameLevel: .one, isLevelLocked: false, clockColor: Color(red: 0, green: 0.5603182912, blue: 0))
                    }//always open

                    
                    Button {
                        
                        self.tbGameLevel = .two
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.gameChoice = 2
                        }
                        
                    } label: {
                        
                        TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight, tbGameLevel: .two, isLevelLocked: apGK.isLocked.level2 ?? true, clockColor: Color(red: 0.45, green: 0, blue: 0))
                        
                    }//.disabled(!isLevelUnlocked.level_2)
                    .disabled(apGK.isLocked.level2 ?? true)
                                    
                }
                
                HStack {
                    
                    Button {
                        
                        self.tbGameLevel = .three
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.gameChoice = 2
                        }
                                                
                    } label: {
                        
                        TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight, tbGameLevel: .three, isLevelLocked: apGK.isLocked.level3 ?? true, clockColor: Color(red: 0, green: 0.1, blue: 0.6))
                        
                    }//.disabled(!isLevelUnlocked.level_3)
                    .disabled(apGK.isLocked.level3 ?? true)
                   
                    Button {
                        
                        self.tbGameLevel = .four
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.gameChoice = 2
                        }
                        
                    } label: {
                        
                        TimeBankSelectionView(screenWidth: screenWidth, screenHeight: screenHeight, tbGameLevel: .four, isLevelLocked: apGK.isLocked.level4 ?? true, clockColor: Color(red: 0.6, green: 0.5, blue: 0))
                        
                    }//.disabled(!isLevelUnlocked.level_4)
                    .disabled(apGK.isLocked.level4 ?? true)
                    
                    
                    
                }
                
     
            }
            
         /*  Text("Show The Nut")
                    .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.yellow)
                    .frame(maxWidth:screenWidth)
                    .frame(height: screenWidth * 0.12, alignment: .center)
                    .padding()
                    .background(Color(CGColor(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5)) */
        }
    }
    
}

/*struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} */


