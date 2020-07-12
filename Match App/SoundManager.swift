//
//  SoundManager.swift
//  Match App
//
//  Created by radjiv carrere on 7/11/20.
//  Copyright © 2020 radjiv carrere. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        var soundFilename = ""
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        //Get the path to the sound file
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("we could not find sound \(soundFilename)")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        //Create audio player
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("cant create audio player")
        }
    }
}
