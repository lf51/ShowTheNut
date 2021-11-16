//
//  MyCardsView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 12/10/21.
//

import SwiftUI

struct MyCardsView: View {
    
    @ObservedObject var vm: AlgoritmoGioco
    
    var cardWidth = UIScreen.main.bounds.width * 0.16
    
    func pickANewCardBeforeRiver() {
        
        vm.changingCardAvaible = false
        vm.areCardsUnpickable = false
    }
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .bottom){
            
                Image(vm.myCards[0])
                    .resizable()
                    .scaledToFit()
                    .frame(width:cardWidth, height: cardWidth * 1.4)
                    .cornerRadius(cardWidth / 14)
                    .shadow(radius: cardWidth / 14)
                    .onTapGesture {
                        
                        vm.myCardRemoved = vm.myCards[0]
                        vm.myCards[0] = "retroCarta2"
                        pickANewCardBeforeRiver()
                        
                    }.disabled(!vm.changingCardAvaible)
                    .opacity(vm.myCards[0] == "retroCarta2" ? 0.0 : 1.0)
                    .overlay(
                        VStack{
                            
                            if vm.myCards[0] == "retroCarta2" {
                                
                               ZStack{
                                    
                                    Color.white.opacity(0.1).cornerRadius(cardWidth/14)
                                    
                                    if !vm.areCardsUnpickable {
                                        
                                        Text("Pick")
                                            .font(Font.system(size: (cardWidth * 0.30), weight: .bold, design: .monospaced))
                                    }
                               }
       
                            }
                  
                        }
                      
                    )
                    .offset(y: vm.playerWin ? -(cardWidth * 0.50): 0.0)
                
                Image(vm.myCards[1])
                    .resizable()
                    .scaledToFit()
                    .frame(width:cardWidth, height: cardWidth * 1.4)
                    .cornerRadius(cardWidth / 14)
                    .shadow(radius: cardWidth / 14)
                    .onTapGesture {
                        
                        vm.myCardRemoved = vm.myCards[1]
                        vm.myCards[1] = "retroCarta2"
                        pickANewCardBeforeRiver()
                        
                    }.disabled(!vm.changingCardAvaible)
                    .opacity(vm.myCards[1] == "retroCarta2" ? 0.0 : 1.0)
                    .overlay( VStack {
                        
                        if vm.myCards[1] == "retroCarta2" {
                            
                           ZStack{
                                
                                Color.white.opacity(0.1).cornerRadius(cardWidth/14)
                                
                                if !vm.areCardsUnpickable {
                                    
                                    Text("Pick")
                                        .font(Font.system(size: (cardWidth * 0.30), weight: .bold, design: .monospaced))
                                }
                           }
   
                        }
                                
                        if vm.showNuts {
                            
                            Image(systemName: vm.playerWin ? "checkmark.circle.fill" : "multiply.circle.fill")
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: (cardWidth * 0.40), y: -(cardWidth * 0.70))
                                .font(.system(size: cardWidth * 0.40))
                                .foregroundColor(vm.playerWin ? Color.green : Color.red)
                                .transition(AnyTransition.opacity.animation(Animation.linear(duration: 1.0)))
                            
                        }
                        
                    })

                    .offset(y: vm.playerWin ? -(cardWidth * 0.50) : 0.0)
                
            }
            .padding(.bottom)
            .animation(Animation.easeInOut(duration: 0.5),value: vm.playerWin)
        }
    }
}
/*struct MyCardsView_Previews: PreviewProvider {
    static var previews: some View {
        MyCardsView()
    }
}
*/
