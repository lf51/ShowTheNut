//
//  BoardView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 12/10/21.
//

import SwiftUI

struct BoardView: View {
    
    @ObservedObject var vm: AlgoritmoGioco
    
    var cardWidth = UIScreen.main.bounds.width * 0.14
    
    var body: some View {
        
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: cardWidth / 17.5){
            
          
            if vm.isFlopReady {
                    
                Image(vm.flop[0]).resizable()
                    .scaledToFit()
                    .frame(width:cardWidth,height:cardWidth * 1.4)
                    .cornerRadius(cardWidth / 14)
                    .shadow(radius: cardWidth / 14)
                    .opacity(vm.showNuts && !vm.goodCardInTheBoard.contains(vm.flop[0]) ? 0.6 : 1.0)
                    .offset(y: vm.goodCardInTheBoard.contains(vm.flop[0]) ? -(cardWidth * 0.50) : 0.0)
                   // .transition(AnyTransition.offset(x:0.0))
                   // .animation(.linear(duration: 4.0))
                
                    Image(vm.flop[1]).resizable()
                        .scaledToFit()
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .cornerRadius(cardWidth / 14)
                        .shadow(radius: cardWidth / 14)
                        .opacity(vm.showNuts && !vm.goodCardInTheBoard.contains(vm.flop[1]) ? 0.6 : 1.0)
                        .offset(y: vm.goodCardInTheBoard.contains(vm.flop[1]) ? -(cardWidth * 0.50) : 0.0)
                        .transition(AnyTransition.offset(x: -cardWidth))
                        .animation(.easeOut(duration: 0.5))
                
                    Image(vm.flop[2]).resizable()
                        .scaledToFit()
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .cornerRadius(cardWidth / 14)
                        .shadow(radius: cardWidth / 14)
                        .opacity(vm.showNuts && !vm.goodCardInTheBoard.contains(vm.flop[2]) ? 0.6 : 1.0)
                        .offset(y: vm.goodCardInTheBoard.contains(vm.flop[2]) ? -(cardWidth * 0.50) : 0.0)
                        .transition(AnyTransition.offset(x: -(cardWidth*2)))
                        .animation(.easeIn(duration: 0.5)) // differente da flop[1] per farle muovere a velocità diverse
                    
                } else {
               
                    RoundedRectangle(cornerRadius: cardWidth / 14)
                           // .frame(width:70,height:98)
                            .frame(width:cardWidth,height:cardWidth * 1.4)
                            .foregroundColor(Color.white)
                            .opacity(0.1)
                        
                    RoundedRectangle(cornerRadius: cardWidth / 14)
                       // .frame(width:70,height:98)
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .foregroundColor(Color.white)
                        .opacity(0.1)
                       
                    RoundedRectangle(cornerRadius: cardWidth / 14)
                       // .frame(width:70,height:98)
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .foregroundColor(Color.white)
                        .opacity(0.1)
                       
                }
           
            if vm.isTurnReady {
                
                Image(vm.turn).resizable()
                            .scaledToFit()
                            .frame(width:cardWidth,height:cardWidth * 1.4)
                            .cornerRadius(cardWidth / 14)
                            .shadow(radius: cardWidth / 14)
                            .opacity(vm.showNuts && !vm.goodCardInTheBoard.contains(vm.turn) ? 0.6 : 1.0)
                            .offset(y: vm.goodCardInTheBoard.contains(vm.turn) ? -(cardWidth * 0.50) : 0.0)
                            .transition(AnyTransition.move(edge: .bottom))
                            .animation(.linear)
                
            } else {
                
                RoundedRectangle(cornerRadius: cardWidth / 14)
                   // .frame(width:70,height:98)
                    .frame(width:cardWidth,height:cardWidth * 1.4)
                    .foregroundColor(Color.white)
                    .opacity(0.1)
            }
            
         
                if vm.isRiverReady {
                    
                    Image(vm.river).resizable()
                        .scaledToFit()
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .cornerRadius(cardWidth / 14)
                        .shadow(radius: cardWidth / 14)
                        .opacity(vm.showNuts && !vm.goodCardInTheBoard.contains(vm.river) ? 0.6 : 1.0)
                        .offset(y: vm.goodCardInTheBoard.contains(vm.river) ? -(cardWidth * 0.50) : 0.0)
                        .transition(AnyTransition.move(edge: .bottom))
                        .animation(.linear)
                    
                    
                } else {
                    
                    RoundedRectangle(cornerRadius: cardWidth / 14)
                       // .frame(width:70,height:98)
                        .frame(width:cardWidth,height:cardWidth * 1.4)
                        .foregroundColor(Color.white)
                        .opacity(0.1)
                }
            
        }
        .animation(Animation.easeOut(duration: 0.5), value: vm.goodCardInTheBoard)
  
    }
}


/*struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
} */
