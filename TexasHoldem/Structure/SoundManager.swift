//
//  SoundManager.swift
//  TexasHoldem
//
//  Created by Calogero Friscia on 28/10/21.
//

import AVKit

class SoundManager {
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        
        case success
        case lose
        case allin
        case cardsShuffle
        case coindrop
        case check
        case cardClip
        case cardShuffler
        case cardShuffle
        
    }
    
    func playSound(sound: SoundOption) {
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {return}
        
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            
            print("Error playing sound. \(error.localizedDescription)")
        }
             
    }
}
