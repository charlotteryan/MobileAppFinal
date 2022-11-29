//
//  PastPuzzlesViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit

class PastPuzzlesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Puzzles"
        // Do any additional setup after loading the view.
    }
    
    // Used to return directly from Win to PastPuzzles
    @IBAction func unwindToPastPuzzles(_ segue: UIStoryboardSegue) {
    }
    

    // Code below is used to fetch puzzle data on click -- a bit slow -- use activity indicator
    
//    @IBAction func clickPlayToday(_ sender: Any) {
//        let group = DispatchGroup()
//        group.enter()
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            print("Call get boards")
//            self.getBoards(date: Date.now, completionHandler: { () in
//                group.leave()
//                print("leaving group")
//            })
//            print("After get boards")
//
//        }
//
//        group.notify(queue: .global(qos: .userInitiated)) {
//            DispatchQueue.main.async {
//                print("Perform segue")
//                self.performSegue(withIdentifier: "homeToDailyPuzzle", sender: sender)
//            }
//        }
//    }
    
//    // Fetch the boards from Firebase
//    func getBoards(date: Date, completionHandler: @escaping() -> Void) {
//        print("In get boards")
//        // Get today's date as a string
//        let format = DateFormatter()
//        format.dateFormat = "MM_dd_yyyy"
//        let dateString = format.string(from: Date.now) // used to fetch data from Firebase
//        format.dateFormat = "MMMM d, yyyy"
//        self.longDate = format.string(from: Date.now) // used for title of puzzle page
//        
//        ref.child("Boards/11_29_2022").observeSingleEvent(of: .value, with: { snapshot in
//            let value = snapshot.value as? NSDictionary
//            self.solvedBoard = value?["solvedBoard"] as? String ?? "xSolved"
//            self.unsolvedBoard = value?["unsolvedBoard"] as? String ?? "xUnsolved"
//            completionHandler()
//        }) { error in
//            print(error.localizedDescription)
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
