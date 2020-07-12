//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by radjiv carrere on 7/9/20.
//  Copyright © 2020 radjiv carrere. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    var card:Card?
    
    func setCard(_ card:Card){
        //keep track of the card that gets passed in
        self.card = card
        
        if card.isMatched == true {
            // if the app has been matched
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }

        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if the cad is in a flipped up state or flipped
        if card.isFlipped == true {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0 , options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        
        else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0 , options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        let card = self.card
        card?.isFlipped = true
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3 , options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        let card = self.card
        card?.isFlipped = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3 , options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove() {
        // Remove both imageview from being visible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut,  animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
