//
//  MyInfoViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase

class MyInfoViewController: UIViewController {
    
    let ref = Database.database().reference()
    //All the various lables for user statistics
    @IBOutlet weak var averageTimeText: UILabel!
    @IBOutlet weak var mistakesMadeText: UILabel!
    @IBOutlet weak var puzzleStreakText: UILabel!
    @IBOutlet weak var totalSolvedPuzzlesText: UILabel!
    
    @IBOutlet weak var usernameText: UITextField!
    
    var currentUsername = UserDefaults.standard.string(forKey: "Username")
    
    
    //TODO: make the username display in the other view controllers wherever needed
    //TODO: fetch data from database to update stats
    
    //Change username button and alert popup
    @IBAction func changeUsernameButton(_ sender: Any) {
        if usernameText.text != nil{
            print(currentUsername)
            print(usernameText.text)
            print(ref.child("Users/\(UIDevice.current.identifierForVendor!.uuidString)/username"))
            ref.child("Users/\(UIDevice.current.identifierForVendor!.uuidString)/username").setValue(usernameText.text)
            currentUsername = usernameText.text
            UserDefaults.standard.set(usernameText.text, forKey: "Username")
            usernameText.text = UserDefaults.standard.string(forKey: "Username")
            usernameChangeAlert()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameSetup()
        // Do any additional setup after loading the view.
    }
    //displays an alert for when the user presses the change name button
    func usernameChangeAlert(){
        let alertController = UIAlertController(title: "", message:
                "Username Changed Successfully!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
    //setting up username, checks if there is already a username saved first. If not, it auto generates one and saves that. If there is one saved then it just loads that
    func usernameSetup(){
        currentUsername = UserDefaults.standard.string(forKey: "Username")
        usernameText.text = UserDefaults.standard.string(forKey: "Username")
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
