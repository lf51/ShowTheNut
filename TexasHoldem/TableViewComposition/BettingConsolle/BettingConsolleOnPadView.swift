//
//  BettingConsolleOnPhoneView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 01/12/21.
//

import SwiftUI

struct BettingConsolleOnPadView: View {
    
    var screenWidth:CGFloat
    
    @ObservedObject var vm: AlgoritmoGioco
    @ObservedObject var ga: GameAction
    @ObservedObject var gl: GameLevel
    
    var areFichesDisabled:Bool
    
    var body: some View {
        
        if vm.stepCount <= 2 {
            
            OpenBettingConsolleOnPadView(vm: vm, ga: ga, gl: gl, areFichesDisabled: areFichesDisabled)
            
        } else {
            
            VStack {
                
                Button {
                    
                    ga.cButton()
                    
                } label: {
                    
                    ChipsView(value: .c,screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                        .padding(.trailing)
                                    }
                
                if vm.stepCount <= 4 {
                    
                    Button {
                        SoundManager.instance.playSound(sound: .allin)
                        ga.allInButton(stepCount: vm.stepCount, blueRectangle: true)
                        
                    } label: {
             
                        Circle()
                            .foregroundColor(Color.blue)
                            .frame(width: (screenWidth/0.7) * 0.06, height: (screenWidth/0.7) * 0.06, alignment: .center)
                            .shadow(color: .black, radius: areFichesDisabled ? 0.0 : 2.0)
                            .opacity(areFichesDisabled ? 0.6 : 1.0)
                            .overlay(Text("3x").font(.system(size: (screenWidth/0.7) * 0.028, weight: .bold, design: .default)).foregroundColor(Color.black),alignment:.center)
                            .padding(.trailing)

                }
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
                
                Button {
                    SoundManager.instance.playSound(sound: .allin)
                    ga.allInButton(stepCount: vm.stepCount, blueRectangle: false)
                    
                } label: {
                    
                    Circle()
                        .foregroundColor(Color.yellow)
                        .frame(width: (screenWidth/0.7) * 0.06, height: (screenWidth/0.7) * 0.06, alignment: .center)
                        .shadow(color: .black, radius: areFichesDisabled ? 0.0 : 2.0)
                        .opacity(areFichesDisabled ? 0.6 : 1.0)
                        .overlay(Text(vm.stepCount <= 4 ? "\(ga.betLimitOnFlop,specifier: "%.0f")x" : "\(ga.betLimitOnTurn,specifier: "%.1f")x").font(.system(size: (screenWidth/0.7) * 0.028, weight: .bold, design: .default)).foregroundColor(Color.black),alignment:.center)
                        .padding(.trailing)
                }
                
                
            }
            
        }
        
        
    }
}

/*
struct BettingConsolleOnPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        BettingConsolleOnPhoneView()
    }
}*/
