//
//  WinViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit

class WinViewController: UIViewController {
    
    var time = "99:99"
    var fromHome = true
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        timeLabel.text = "You completed the puzzle in \(time)"
        
        
        if (fromHome) {
            returnButton.setTitle("Return to Home", for: .normal)
        }
        else {
            returnButton.setTitle("Return to Past Puzzles", for: .normal)
        }
        
        
    }
    
    @IBAction func shareTime(_ sender: Any) {
        // TODO: seems kinda slow -- look into this. Also, can't text since not a real phone - test on real phone
        // TODO: add label for date/test label for puzzle
        let items = ["I solved today's Daily Sudoku Dash puzzle in \(time)! Can you solve it faster?"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func `return`(_ sender: Any) {
        if (fromHome) {
            self.performSegue(withIdentifier: "unwindWinToHome", sender: sender)
        }
        else {
            self.performSegue(withIdentifier: "unwindWinToPastPuzzles", sender: sender)
        }
    }
    
    
    
    // Hide navigation bar -- can't navigate back to puzzle
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Show navigation bar again once we leave
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
