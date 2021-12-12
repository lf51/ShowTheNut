//
//  PreFlop.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 12/10/21.
//

import SwiftUI

struct PreFlopShufflingCards: View {

    @ObservedObject var vm: AlgoritmoGioco
    var idiomDevice: UIUserInterfaceIdiom
    
    var cardWidth = UIScreen.main.bounds.width * 0.12 /*0.08 0.14*/ // come le ALLCARDS mi sembra piccolo, come le board mi sembra grande, per cui abbiamo fatto una via di mezzo fra 0.08 e 0.14
    
    var shuffleBoxWidth = UIScreen.main.bounds.width * 0.75  // iphone 0.75
    
    var centerX = UIScreen.main.bounds.width / 2.0
    var centerY = UIScreen.main.bounds.height / 2.0 // iphone 2.0
    
    var shuffleWidthPadding: Double {
        
   UIScreen.main.bounds.width - shuffleBoxWidth
        
    }
    
    func shuffleCoordinate(stop:Bool,isInMazzoA:Bool) -> CGPoint {
        
        if !stop {
            
            let yStrideFrom:Double = self.idiomDevice == .pad ? (centerY * 1.35) : centerY
            
            var xRange:[Double] = []
            var yRange:[Double] = []
                    
            for y in stride(from: (yStrideFrom - shuffleBoxWidth), to: centerY, by: 0.1) {
                
                yRange.append(y)
             
            }
            
            for x in stride(from: self.shuffleWidthPadding, to: self.shuffleBoxWidth, by: 0.1){

                xRange.append(x)
            }
            
            let xx = xRange.shuffled()[0]
            let yy = yRange.shuffled()[0]
            
            return CGPoint(x:xx,y: yy)
        }
        
        else {
            
            if isInMazzoA {
                //print("è nel mazzo A")
                return CGPoint(x:(centerX + (cardWidth * 1.5)),y: centerY) }
                
             else {
                // print("NON è nel mazzo A")
                 return CGPoint(x:centerX,y: centerY) }
            }
            
             // Impstare la posizione rispetto al Board
        
    }
    
    func rotationAngle(stop:Bool) -> Double{
        
        if !stop {
            
            var angleArray:[Double] = []
            
            for x in 0...360 {
                
                angleArray.append(Double(x))
                
            }
            
            let angle = angleArray.shuffled()[0]
            return angle
            
        } else {return 0.0 }
       
        
    }
    
    func customShadow()->(radius:CGFloat,x:CGFloat) {
        
        if vm.stopShuffle {
            
            return(1.0,-0.1)
            
            
        } else {return ((cardWidth / 25),-0.1) }
        
        
    }
    
    var body: some View {
        
        HStack {
            
            ZStack{
                ForEach(vm.shuffledCards, id:\.self){ card in
                    
                    Image(vm.stopShuffle ? "retroCarta2" : card)
                        .resizable()
                        .scaledToFit()
                        .frame(width:cardWidth, height: (cardWidth * 1.4))
                        .cornerRadius(cardWidth / 14)
                        
                        .shadow(color: .black, radius:customShadow().radius, x: customShadow().x, y: 0.0)

                        .rotationEffect(Angle(degrees: rotationAngle(stop: vm.stopShuffle)))
                        .position(shuffleCoordinate(stop: vm.stopShuffle,isInMazzoA: vm.mazzoA.contains(card)))
                        .animation(Animation.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0.0), value: vm.stopShuffle)
                        .zIndex(1.0)
                        
                    
                }.animation(.spring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.0))
                
                if vm.stopShuffle {
                  
                        
                        RoundedRectangle(cornerRadius: cardWidth / 14)
                            .foregroundColor(.red)
                            .frame(width:cardWidth, height: (cardWidth * 1.4))
                            .position(x: (centerX + (cardWidth * 1.5)), y: centerY)
                            .transition(AnyTransition.move(edge: .bottom))
                            .animation(Animation.easeInOut(duration: 1.0))
                            .zIndex(0.0)
                    
                }
                
                
                    
                
            }//.padding(.bottom, (cardWidth / 5))
            
            
            
        }
        
    }
    
    
    
}

/*struct PreFlop_Previews: PreviewProvider {
    static var previews: some View {
        PreFlop()
    }
}*/
