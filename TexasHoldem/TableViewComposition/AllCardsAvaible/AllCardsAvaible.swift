//
//  AllCardsAvaible.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 12/10/21.
//

import SwiftUI

struct AllCardsAvaible: View {
    
    @ObservedObject var vm: AlgoritmoGioco
    
    var cardWidth = UIScreen.main.bounds.width * 0.08
    
    var isPickAvaible:Bool {
        
        return false
    }
    
    var body: some View {
        VStack{

                
                VStack(alignment:.leading) {
                    
                    ForEach(["c","q","f","p"],id:\.self){ seed in
                        
                    HStack(spacing:-(cardWidth / 5.0)) {
                        
                        ForEach(vm.allCardsShowed.filter{$0.hasSuffix(seed)}, id:\.self){ card in
                            
                            Image(card)
                                .resizable()
                                .scaledToFit()
                                .frame(width:cardWidth, height: (cardWidth * 1.4))
                                .cornerRadius(cardWidth / 14)
                                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: (cardWidth / 25), x: -1.0, y: 0.0)
                                .onTapGesture(perform: {

                                    vm.pickACard(card: card)
                                    
                                }).disabled(vm.areCardsUnpickable)
                            
                        }
                        
                    }.padding(.bottom, (cardWidth / 5))
                    
                }
                   
                    
                }
                .padding()
               /* .onChange(of: vm.myCards, perform: { pocketCards in
                        
                        if !pocketCards.contains("retroCarta2") {
                            
                          //  vm.showCardsPickable = false
                            
                            if vm.stepCount == 2 { // serve a switchare fra il pick dopo flop e dopo turn
                                vm.showTurn()
                                
                            } else if vm.stepCount == 3 {vm.changeAction()}
                            
                        }
                    })*/
                    .animation(Animation.easeIn(duration: 0.5), value: vm.allCardsShowed)
        
            
        }
    }
}

/*struct AllCardsAvaible_Previews: PreviewProvider {
    static var previews: some View {
        AllCardsAvaible()
    }
} */
