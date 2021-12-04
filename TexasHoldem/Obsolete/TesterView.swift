//
//  GameTester.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 01/11/21.
//

import Foundation
import SwiftUI
import GameKit

/*struct TesterView: View {
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
    
    
        
       NavigationView {
            
            ZStack {
                
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    NavigationLink {
                        
                        ClassicGameView()
                        
                    } label: {
                        
                        Text("Classic")
                            .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.black)
                            // .resizable()
                            // .scaledToFill()
                            // .padding(.horizontal)
                             .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                             
                             .background(Color(CGColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                             .ignoresSafeArea()
                    }

                    NavigationLink {
                        
                        TimeBankView()
                        
                    } label: {
                        
                        Text("TimeBank 60'")
                            
                            .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(CGColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                            .lineLimit(1)
                            .scaleEffect()
                           // .padding()
                            // .resizable()
                            // .scaledToFill()
                            // .padding(.horizontal)
                             .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                             
                             .background(Color(CGColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)))
                             .edgesIgnoringSafeArea(.bottom)
                    }
                Spacer(minLength: .infinity)
                      
                }
                
           /*     Text("Show The Nut")
                    .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.yellow)
                    .frame(width: screenWidth, height: .infinity, alignment: .center)
                    .padding()
                    .background(Color(CGColor(red: 0, green: 0, blue: 0, alpha: 1))) */
                    
                
                
            }
       }.navigationBarHidden(true)
 
        
        
        
        
    }
   
} */




struct TesterView: View {
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
     
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack{
                
                ZStack {
                    
                    Image("ClassicGame")
                         .resizable()
                         .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                         .opacity(0.8)
                         .ignoresSafeArea()
                    
                    Text("Classic Game")
                          .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                          .foregroundColor(Color(CGColor(red: 1, green: 1, blue: 1, alpha: 1)))
                          .padding(.top, screenWidth / 2)
                    
                }
          
                
                ZStack {
                    
                    Image("ClassicGame")
                         .resizable()
                         .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                         .opacity(0.2)
                      
                     .edgesIgnoringSafeArea(.bottom)
                    
                   Image(systemName: "clock.fill")
                         .resizable()
                         .scaledToFit()
                         .foregroundColor(Color.yellow)
                         .padding()
                         .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                         .opacity(0.2)
                         .edgesIgnoringSafeArea(.bottom)

                  Text("TimeBank 60'")
                        .font(.system(size: screenWidth * 0.10, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(CGColor(red: 1, green: 1, blue: 1, alpha: 1)))
                        .padding(.top, screenWidth / 2)
                    
                }
              //  .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
              //  .edgesIgnoringSafeArea(.bottom)
        
            }
        }
 
        
        
        
        
    }
   
}

/*struct TesterView: View {
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {

        
        
        
        ZStack {
            
            Color.black
            
            
            VStack{
                
                Image(systemName: "phone.down")
                     .resizable()
                     .scaledToFit()
                     .padding(.horizontal)
                     .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                     
                     .background(Color.yellow)
                     .ignoresSafeArea()
          
                Image(systemName: "clock.arrow.circlepath")
                     .resizable()
                     .scaledToFit()
                     .padding(.horizontal)
                     .frame(width: screenWidth, height: screenHeight / 2, alignment: .center)
                     .background(Color.blue)
                     .edgesIgnoringSafeArea(.bottom)
                
        
            }
        }
 
        
        
        
        
    }
   
}*/

struct TesterView_Previews: PreviewProvider {
    static var previews: some View {
        TesterView()
    }
}
