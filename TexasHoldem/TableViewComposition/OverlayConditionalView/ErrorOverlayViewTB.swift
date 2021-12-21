//
//  FinalResultOverlayView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 21/10/21.
//

import SwiftUI

struct ErrorOverlayViewTB: View {
    
    @ObservedObject var apGK:AuthPlayerGK
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        VStack {
            
            Spacer()
              ZStack {
                
                    Color.red.opacity(0.8)
                  
                    HStack{
                      
                        Text("Error to connect your Game Center Account -> Check the account setting or the internet connection.\n\(apGK.error ?? "") ")
                            .foregroundColor(Color.white)
                            .lineLimit(3)
                            .minimumScaleFactor(0.3)
                            .font(.system(size: screenWidth * 0.02))
                            .padding(.horizontal)
                        
                        Divider()
                        Spacer()
                        
                        Button {
                               apGK.showError = false
                               
                           } label: {
                               
                               Text("close")
                                   .bold()
                                   .foregroundColor(Color.blue)
                                   .font(.system(size: screenWidth * 0.02))
                                   
                           }
                   
                        Spacer()
                    }
               
            }
            .frame(maxWidth:.infinity)
            .frame(height: screenWidth / 10)
            .offset(y: -(screenWidth / 10))

        }
        
    }
}


