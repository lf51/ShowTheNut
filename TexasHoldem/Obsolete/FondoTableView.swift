//
//  FondoTableView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 07/10/21.
//

import SwiftUI

struct FondoTableView: View {
    
    var level:[TableLevel] = [.green,.red,.blue,.gold,.black]
    
    @State private var levelIndex = 0
    
    var test:Float {
        
        let firstStep:Float = (3 / 4) * 100
        
        return firstStep
        
    }
    
    
    var body: some View {
  
        ZStack {
            
     // Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)).ignoresSafeArea()
            
            
            Color(CGColor(red: 0, green: 0, blue: 0, alpha: 1)).ignoresSafeArea().opacity(0.8)
            
            Text("\(test)")
            
            
      //  Color(CGColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1)).ignoresSafeArea()
            
   //  Color(CGColor(red: 0.45, green: 0, blue: 0, alpha: 1))
          
    // Color( CGColor(red: 0, green: 0.1, blue: 0.6, alpha: 1))
            
     // Color(CGColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1))

            
      /* Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .opacity(0.05) */
            
          //  Rectangle().cornerRadius(170.0).padding().foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
            
        //    Rectangle().cornerRadius(130.0).padding(60).foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))).opacity(0.6)
            
       //     Rectangle().cornerRadius(110.0).padding(130).foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
            
            ZStack{
                
            //    Rectangle().frame(width: 115, height: 180).foregroundColor(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))).cornerRadius(10.0)
                      
                
            }.position(x: 72, y: 400)

            
            
            
        
    }
}
}

struct FondoTableView_Previews: PreviewProvider {
    static var previews: some View {
        FondoTableView()
    }
}


