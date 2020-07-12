//
//  CardModel.swift
//  Match App
//
//  Created by radjiv carrere on 7/9/20.
//  Copyright © 2020 radjiv carrere. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store numbers already generated
        var generatedNumbersArray = [Int]()
        
        var generatedCardArray = [Card]()
        
        while generatedNumbersArray.count < 8 {
            // Get random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                // Store number inside generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardOne)
                
                // Create the first card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardTwo)
            }
        }
        
        // Randomize the array
        for i in 0...generatedCardArray.count-1 {
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
           let temporaryStorage = generatedCardArray[i]
           generatedCardArray[i] = generatedCardArray[randomNumber]
           generatedCardArray[randomNumber] = temporaryStorage
        }
        
       
        
        return generatedCardArray
    }

}
