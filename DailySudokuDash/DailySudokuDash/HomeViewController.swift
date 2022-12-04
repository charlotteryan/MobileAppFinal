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
    
    var timer:Timer = Timer()
    var hours:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    @IBOutlet weak var todaysTime: UILabel!
    @IBOutlet weak var fetchErrorMessage: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playTodayButton: UIButton!
    @IBOutlet weak var timeUntilNextPuzzle: UILabel!
    @IBOutlet weak var timerUntilNextPuzzle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIREBASE TESTING LINES
//        UserDefaults.standard.set(nil, forKey: "username")
        
        usernameSetup()
        checkDate()
        createTimer()
        fetchErrorMessage.isHidden = true
//        UserDefaults.standard.removeObject(forKey: "lastPuzzleDate")
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
    
    // Hide navigation bar -- don't need nav bar on home screen
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if(!UserDefaults.standard.bool(forKey: "completedDaily")){
            playTodayButton.isHidden = false
            timeUntilNextPuzzle.isHidden = true
            timerUntilNextPuzzle.isHidden = true
            todaysTime.isHidden = true
            createTimer()
        }
        else {
            playTodayButton.isHidden = true
            timeUntilNextPuzzle.isHidden = false
            timerUntilNextPuzzle.isHidden = false
            todaysTime.isHidden = false
            todaysTime.text = "You solved today's puzzle in \( UserDefaults.standard.string(forKey: "todaysTime") ?? "Error")"
        }
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
        }
    }
    
    // Fetch the boards from Firebase
    func getBoards(date: Date, completionHandler: @escaping(Bool) -> Void) {
        // Get today's date as a string
        let format = DateFormatter()
        format.dateFormat = "MM_dd_yyyy"
        let dateString = format.string(from: date) // used to fetch data from Firebase
        format.dateFormat = "MMMM d, yyyy"
        self.longDate = format.string(from: date) // used for title of puzzle page

        ref.child("Boards/" + dateString).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.solvedBoard = value?["solvedBoard"] as? String ?? "123458679456179238789236145241365897367892451895714362632987514578641923914523786"
            self.unsolvedBoard = value?["unsolvedBoard"] as? String ?? ".23458679456179238789236145241365897367892451895714362632987514578641923914523786"
            completionHandler(true)
        })
        { error in
            print(error.localizedDescription)
            completionHandler(false)
        }
    }
    
    func usernameSetup(){
        //checking if there is already a username saved, if not, auto-generating random username
        if UserDefaults.standard.string(forKey: "username") == nil{
            let usernameInt = Int.random(in: 1..<999999)
            var username = "SudokuLover"
            username = username+"\(usernameInt)"
            UserDefaults.standard.set(username, forKey: "username")
            ref.child("Users").child(UIDevice.current.identifierForVendor!.uuidString).setValue(["username": username])
            
            UserDefaults.standard.set(0, forKey: "dailyPuzzleStreak")
            UserDefaults.standard.set(0, forKey: "totalSolvedPuzzles")
            UserDefaults.standard.set(0, forKey: "incorrectPuzzleSubmissions")
            UserDefaults.standard.set(0, forKey: "totalPuzzleTime") // used for avg time
            // TODO: remove mentions of completedDaily, instead use lastDayPlayed
        }
    }
    
    func createTimer() {
        let currentDate = Date()
        var nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        nextDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nextDate)!

        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate, to: nextDate)
        hours = diffComponents.hour!
        minutes = diffComponents.minute!
        seconds = diffComponents.second!
    
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func fireTimer() {
        if seconds-1 == -1 {
            minutes-=1
            seconds = 59
        }
        else{
            seconds -= 1
        }
        if minutes == -1 {
            minutes=59
            hours -= 1
        }
        
        var stringSec = String(describing: seconds)
        var stringMin = String(describing: minutes)
        var stringHours = String(describing: hours)
        if seconds == 0 {
            stringSec = "00"
        }
        if seconds < 10{
            stringSec = "0" + String(describing: seconds)
        }
        if minutes < 10{
            stringMin = "0" + stringMin
        }
        if hours < 10{
            stringHours = "0" + stringHours
        }
        timerUntilNextPuzzle.text = stringHours + " : " + stringMin + " : " + stringSec
        
        if(minutes == 0 && seconds == 0 && hours == 0){
            UserDefaults.standard.set(false, forKey: "completedDaily")
            playTodayButton.isHidden = false
            timerUntilNextPuzzle.isHidden = true
            timeUntilNextPuzzle.isHidden = true
        }
    }
    
    func checkDate(){
        let completedPuzzle = UserDefaults.standard.bool(forKey: "completedDaily")
        if(completedPuzzle){
            let format = DateFormatter()
            format.dateFormat = "MM_dd_yyyy"
            let dateString = format.string(from: Date.now)
            let lastPuzzleDate = UserDefaults.standard.string(forKey: "lastPuzzleDate")
            if (dateString != lastPuzzleDate){
                UserDefaults.standard.set(false, forKey: "completedDaily")
            }
        }
        
    }
}
