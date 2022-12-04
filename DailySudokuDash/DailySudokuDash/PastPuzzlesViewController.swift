//
//  PastPuzzlesViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase

class PastPuzzlesViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let ref = Database.database().reference()
    var selectedDate : Date = Date.now
    var longDate = ""
    var solvedBoard = ""
    var unsolvedBoard = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Past Puzzles"
        
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date.now) // yesterday
        datePicker.date = Calendar.current.date(byAdding: .day, value: -1, to: Date.now) ?? Date.now // yesterday
        selectedDate = datePicker.date
    }
    
    // Used to return directly from Win to PastPuzzles
    @IBAction func unwindToPastPuzzles(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func selectedNewDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    
    @IBAction func clickPlay(_ sender: Any) {
        let group = DispatchGroup()
        group.enter()

        DispatchQueue.global(qos: .userInitiated).async {
            print("Call get boards")
            self.getBoards(date: self.selectedDate, completionHandler: { () in
                group.leave()
            })

        }

        group.notify(queue: .global(qos: .userInitiated)) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "pastToPuzzle", sender: sender)
            }
        }
    }
    
    // Fetch the boards from Firebase
    func getBoards(date: Date, completionHandler: @escaping() -> Void) {
        // Get today's date as a string
        let format = DateFormatter()
        format.dateFormat = "MM_dd_yyyy"
        let dateString = format.string(from: date) // used to fetch data from Firebase
        format.dateFormat = "MMMM d, yyyy"
        self.longDate = format.string(from: date) // used for title of puzzle page
        
        ref.child("Boards/" + dateString).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.solvedBoard = value?["solvedBoard"] as? String ?? "xSolved"
            self.unsolvedBoard = value?["unsolvedBoard"] as? String ?? "xUnsolved"
            completionHandler()
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pastToPuzzle") {
            guard let puzzleVC = segue.destination as? PuzzleViewController else {return}
            
            // Set the board's puzzles to the fetched puzzles
            puzzleVC.solvedBoard = solvedBoard
            puzzleVC.unsolvedBoard = unsolvedBoard
            
            puzzleVC.viewTitle = longDate
            puzzleVC.fromHome = false
        }
    }

}
