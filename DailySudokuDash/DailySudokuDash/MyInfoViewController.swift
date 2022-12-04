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
    
    
    //Change username button and alert popup
    @IBAction func changeUsernameButton(_ sender: Any) {
        if usernameText.text != nil{
            
            //Checks for if Username is already in database
            let Usernames = ref.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: usernameText.text)

            Usernames.observeSingleEvent(of: .value, with: { (snapshot) in

                print(snapshot)
                if snapshot.exists() {

                    print("Username already exists")
                    self.noUsernameChangeAlert()
                } else {

                    print("Username doesn't already exist")
                    self.ref.child("Users/\(UIDevice.current.identifierForVendor!.uuidString)/username").setValue(self.usernameText.text)
                    self.currentUsername = self.usernameText.text
                    UserDefaults.standard.set(self.usernameText.text, forKey: "Username")
                    self.usernameText.text = UserDefaults.standard.string(forKey: "Username")
                    self.usernameChangeAlert()

                }

            }, withCancel: nil)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        puzzleStreakText.text = String(UserDefaults.standard.integer(forKey: "dailyPuzzleStreak"))
        totalSolvedPuzzlesText.text = String(UserDefaults.standard.integer(forKey: "totalSolvedPuzzles"))
        mistakesMadeText.text = String(UserDefaults.standard.integer(forKey: "incorrectPuzzleSubmissions"))
        if (UserDefaults.standard.integer(forKey: "totalSolvedPuzzles") > 0) {
            let avgSeconds = UserDefaults.standard.integer(forKey: "totalPuzzleTime") / UserDefaults.standard.integer(forKey: "totalSolvedPuzzles")
            
            let minutes = avgSeconds / 60
            let seconds = avgSeconds - (60 * minutes)
            var stringSec = String(describing: seconds)
            var stringMin = String(describing: minutes)
            if seconds == 60 {
                stringSec = "00"
            }
            if seconds < 10{
                stringSec = "0" + String(describing: seconds)
            }
            if minutes < 10{
                stringMin = "0" + stringMin
            }
            let timeString = stringMin + ":" + stringSec
            
            averageTimeText.text = timeString
        }
    }
    
    //displays an alert for when the user presses the change name button
    func usernameChangeAlert(){
        let alertController = UIAlertController(title: "", message:
                "Username Changed Successfully!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
    
    func noUsernameChangeAlert(){
        let alertController = UIAlertController(title: "", message:
                "Username Taken! Please pick another username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
    
    
    //setting up username, checks if there is already a username saved first. If not, it auto generates one and saves that. If there is one saved then it just loads that
    // TODO: what is this code actually doing? Why not just load the data in directly?
    func usernameSetup(){
        currentUsername = UserDefaults.standard.string(forKey: "Username")
        usernameText.text = UserDefaults.standard.string(forKey: "Username")
    }
}
