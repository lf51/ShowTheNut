//
//  BettingConsolleOnPadView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 18/10/21.
//

import SwiftUI

struct BettingConsolleOnPadView: View {
    
    @ObservedObject var vm: AlgoritmoGioco
    @ObservedObject var ga: GameAction
    @ObservedObject var gl: GameLevel
    
    var areFichesDisabled:Bool 
    
    var body: some View {
        
        HStack{
            
            VStack{
                
                Button {
                    SoundManager.instance.playSound(sound: .coindrop)
                    ga.betButton(bet: gl.middleValue, stepCount: vm.stepCount)
                } label: {
                    ChipsView(value: .middle(value:gl.middleValue),screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                }
                
                Button {
                    SoundManager.instance.playSound(sound: .coindrop)
                    ga.betButton(bet: gl.smallBlindValue, stepCount: vm.stepCount)
                } label: {
                    ChipsView(value: .small(value:gl.smallBlindValue),screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                        .padding(.vertical)
                }
                
                Button {
                    ga.cButton()
                } label: {
                    ChipsView(value: .c,screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                }
                
            }
            .padding(.trailing)
            
            
            VStack {
                
                Button {
                    SoundManager.instance.playSound(sound: .coindrop)
                    ga.betButton(bet: gl.highValue, stepCount: vm.stepCount)
                } label: {
                    ChipsView(value: .high(value:gl.highValue),screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                }
                
                Button {
                    SoundManager.instance.playSound(sound: .coindrop)
                    ga.betButton(bet: gl.bigBlindValue, stepCount: vm.stepCount)
                } label: {
                    ChipsView(value: .big(value:gl.bigBlindValue),screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                        .padding(.vertical)
                }
                
                Button {
                    SoundManager.instance.playSound(sound: .allin)
                    ga.allInButton(stepCount: vm.stepCount)
                } label: {
                    ChipsView(value: .all,screenReduction: 0.10, areFichesDisabled: areFichesDisabled)
                }
                
            }
            
        }
    }
}
