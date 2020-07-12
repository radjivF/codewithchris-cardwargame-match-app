//
//  ViewController.swift
//  Match App
//
//  Created by radjiv carrere on 7/9/20.
//  Copyright © 2020 radjiv carrere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    var timer: Timer?
    var milliseconds:Float = 30000 // 10 secs
    var firstFlippedCardIndex:IndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Call the get cards methode of the card model
        cardArray = model.getCards()
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElaspsed), userInfo: nil , repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: -Timer Methods
    @objc func timerElaspsed() {
        milliseconds -= 1
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if  there are any card unmatch
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocal Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get an cardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card that the collection will display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Check if there any time left
         
         if milliseconds <= 0 {
             return
         }

        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        if card.isFlipped == false {
            cell.flip()

            SoundManager.playSound(.flip)

            // Determine if its the first card or second card that is flipped over
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                checkForMatches(indexPath)
            }
        }
    }
    
    // MARK: - Game logic methods
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        // Get the cards for the two cards that were revealed
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // compare the two card
        if cardOne.imageName == cardTwo.imageName {
            
            SoundManager.playSound(.match)
            
            // Set the status of the card
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
        else {
            SoundManager.playSound(.nomatch)
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
  
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        // determine if there any card unmatch
        var isWon = true
        var title = ""
        var message = ""
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // if not then the user has won
        if isWon {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulation!"
            message = "You have won"
        }
            
        // check if the user has tome left
        else {
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game over!"
            message = "You have lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title:"Ok", style: .default, handler:nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}

