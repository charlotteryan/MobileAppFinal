//
//  HomeViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let ref = Database.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaults.standard.set(nil, forKey: "Username")
        getBoards()
        usernameSetup()
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
    
    func getBoards(){
        ref.child("Boards/11_21_2022").observeSingleEvent(of: .value, with: { snapshot in
        let value = snapshot.value as? NSDictionary
        let solvedBoard = value?["solvedBoard"] as? String ?? ""
        let unsolvedBoard = value?["unsolvedBoard"] as? String ?? ""
        UserDefaults.standard.set(solvedBoard, forKey: "solvedBoard")
        UserDefaults.standard.set(unsolvedBoard, forKey: "unsolvedBoard")
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    func usernameSetup(){
        //checking if there is already a username saved, if not, auto-generating random
        if UserDefaults.standard.string(forKey: "Username") == nil{
            let usernameInt = Int.random(in: 1..<999999)
            var username = "SudokuLover"
            username = username+"\(usernameInt)"
            UserDefaults.standard.set(username, forKey: "Username")
//            ref.child("Users").child(username).setValue(["averageTime": 0, "mistakesMade": 0, "puzzleStreak": 0, "puzzlesSolved": 0])
        }
    }
}
