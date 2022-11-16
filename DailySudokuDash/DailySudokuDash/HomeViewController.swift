//
//  HomeViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference()
        
        ref.child("Users/SudokuLover373/mistakesMade").setValue(109)
    }
    
    @IBAction func clickPlayToday(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToDailyPuzzle", sender: sender)
    }
    
    @IBAction func clickPlayPast(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToPastPuzzles", sender: sender)
    }
    
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToDailyPuzzle") {
            // TODO: probably fetch puzzle info
        }
    }
}
