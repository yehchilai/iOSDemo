//
//  RollViewController.swift
//  Dice
//
//  Created by Jason Schatz on 11/6/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

// MARK: - RollViewController: UIViewController

class RollViewController: UIViewController {
    
    // MARK: Generate Dice Value
    
    /**
    * Randomly generates a Int from 1 to 6
    */
    func randomDiceValue() -> Int {
        // Generate a random Int32 using arc4Random
        let randomValue = 1 + arc4random() % 6
        
        // Return a more convenient Int, initialized with the random value
        return Int(randomValue)
    }

    // MARK: Actions
    
    @IBAction func rollTheDice() {
       /*
        // First way (Code only) to transfer view with data
        var controller: DiceViewController
        
        controller = self.storyboard?.instantiateViewController(withIdentifier: "DiceViewController") as! DiceViewController
        
        controller.firstValue = self.randomDiceValue()
        controller.secondValue = self.randomDiceValue()
        
        present(controller, animated: true, completion: nil)
        */
    }
    
    @IBAction func rollDiceSegue(_ sender: Any) {
        // Second way (Code & Segue) to transfer view with data through view segue
//        performSegue(withIdentifier: "rollDiceSegue", sender: self)
    }
    
    @IBAction func rollDiceFromButtonSegue(_ sender: Any) {
        // Third way (Segue only) to transfer view with data though button(UI) segue
        
    }
    
    // prepare function is for delivering data to the next view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as!DiceViewController
        
        controller.firstValue = randomDiceValue()
        controller.secondValue = randomDiceValue()
    }
}

