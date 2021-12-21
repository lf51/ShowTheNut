//
//  CustomLoadingView.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 05/12/21.
//

import SwiftUI

struct CustomLoadingView: View {
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.8).ignoresSafeArea()
            
            ProgressView().scaleEffect(2)
            
            
        }
        
    }
}

struct CustomLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingView()
    }
}
