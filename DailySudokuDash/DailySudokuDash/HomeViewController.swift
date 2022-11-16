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
    
    // Hide navigation bar -- don't need nav bar on home screen
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Show navigation bar again once we leave
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Used to return directly from Win to Home
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToDailyPuzzle") {
            // TODO: probably fetch puzzle info
            guard let puzzleVC = segue.destination as? PuzzleViewController else {return}
            puzzleVC.fromHome = true
        }
    }
}
