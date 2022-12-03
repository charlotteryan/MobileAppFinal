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
    var solvedBoard = ""
    var unsolvedBoard = ""
    var longDate = ""
    
    @IBOutlet weak var fetchErrorMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIREBASE TESTING LINES
        UserDefaults.standard.set(nil, forKey: "Username")
//        print(UIDevice.current.identifierForVendor!.uuidString)
//        print(UserDefaults.standard.string(forKey: "Username"))
        
        usernameSetup()
        fetchErrorMessage.isHidden = true
        
//        for i in 6...100{
//            ref.child("LeaderBoard").child("Panda" + String(i)).setValue(["Score": Int.random(in: 1..<5000)])
//        }
    }
    
    
    @IBAction func clickPlayToday(_ sender: Any) {
        let group = DispatchGroup()
        group.enter()
        var fetchSuccess = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            self.getBoards(date: Date.now, completionHandler: { (success: Bool) in
                fetchSuccess = success
                group.leave()
            })
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if (fetchSuccess) {
                    self.performSegue(withIdentifier: "homeToDailyPuzzle", sender: sender)
                }
                else {
                    self.fetchErrorMessage.isHidden = false
                }
            }
        }
    }
    
    @IBAction func clickPlayPast(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToPastPuzzles", sender: sender)
    }
    
    @IBAction func clickTestPuzzle(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToEasyPuzzle", sender: sender)
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
            guard let puzzleVC = segue.destination as? PuzzleViewController else {return}
            
            // Set the board's puzzles to the fetched puzzles
            puzzleVC.solvedBoard = solvedBoard
            puzzleVC.unsolvedBoard = unsolvedBoard
            
            puzzleVC.viewTitle = longDate
            puzzleVC.fromHome = true
            puzzleVC.dailyPuzzleVC = true
        }
        else if (segue.identifier == "homeToEasyPuzzle") {
            guard let puzzleVC = segue.destination as? PuzzleViewController else {return}
            
            // Use default board -- only 1 square missing
            puzzleVC.fromHome = true
            puzzleVC.viewTitle = "Easy Puzzle for Testing"
            puzzleVC.dailyPuzzleVC = true
        }
    }
    
        // Fetch the boards from Firebase
        func getBoards(date: Date, completionHandler: @escaping(Bool) -> Void) {
            // Get today's date as a string
            let format = DateFormatter()
            format.dateFormat = "MM_dd_yyyy"
            let dateString = format.string(from: Date.now) // used to fetch data from Firebase
            format.dateFormat = "MMMM d, yyyy"
            self.longDate = format.string(from: Date.now) // used for title of puzzle page
    
            ref.child("Boards/" + dateString).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                self.solvedBoard = value?["solvedBoard"] as? String ?? "................................................................................."
                self.unsolvedBoard = value?["unsolvedBoard"] as? String ?? "................................................................................."
                completionHandler(true)
            })
            { error in
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    
    func usernameSetup(){
        //checking if there is already a username saved, if not, auto-generating random
        if UserDefaults.standard.string(forKey: "Username") == nil{
            let usernameInt = Int.random(in: 1..<999999)
            var username = "SudokuLover"
            username = username+"\(usernameInt)"
            UserDefaults.standard.set(username, forKey: "Username")
            ref.child("Users").child(UIDevice.current.identifierForVendor!.uuidString).setValue(["username": username, "averageTime": 0, "mistakesMade": 0, "puzzleStreak": 0, "puzzlesSolved": 0])
        }
    }
}
