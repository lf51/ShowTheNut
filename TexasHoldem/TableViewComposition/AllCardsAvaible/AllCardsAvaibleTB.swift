//
//  AllCardsAvaibleTB.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 17/11/21.
//

import SwiftUI

struct AllCardsAvaibleTB: View {
    
    @ObservedObject var vm: AlgoritmoGioco
    
    var cardWidth = UIScreen.main.bounds.width * 0.15
    
    var isPickAvaible:Bool {
        
        return false
    }
    
    var body: some View {
        
        VStack{

            HStack(alignment:.top,spacing: cardWidth / 2.5) {
                    
                    ForEach(["c","q","f","p"],id:\.self){ seed in
                        
                    VStack(spacing:-(cardWidth / 1.2)) {
                        
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
                        
                    }//.padding(.bottom, (cardWidth / 5))
                    
                }
                   
                    
                }
              //  .padding()
    
                    .animation(Animation.easeIn(duration: 0.5), value: vm.allCardsShowed)
        
            
        }
    }
}

/*struct AllCardsAvaibleTB_Previews: PreviewProvider {
    static var previews: some View {
        AllCardsAvaibleTB()
    }
} */
