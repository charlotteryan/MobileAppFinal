//
//  LeaderboardViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase


class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionTitleLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myArray = ["Charlotte", "Madeline", "Ian", "Daniel", "Jake", "Lindsay", "Abby", "Mike", "James", "Brody", "Lydia"]
    var myTimes = ["0.57", "0.99", "1.31", "1.56", "2.13", "2.59", "3.10", "3.59", "12.50", "12.59", "15.10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLeaderBoardData()
        usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCellClass
        cell.num.text = String(describing: indexPath.row+1) + ". "
        cell.name.text = myArray[indexPath.row]
        cell.time.text = myTimes[indexPath.row]
        
        if (myArray[indexPath.row] == UserDefaults.standard.string(forKey: "username")) {
            self.positionLabel.text = String(indexPath.row + 1)
        }
        
        return cell
    }
    
    func loadLeaderBoardData(){
        let group = DispatchGroup()
        group.enter()
        var fetchSuccess = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            self.fetchLeaderBoard(completionHandler: { (success: Bool) in
                fetchSuccess = success
                group.leave()
            })
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if (fetchSuccess) {
                    self.tableView.reloadData()
                }
                else {
                    print("ERROR FETCHING LEADERBOARD")
                }
            }
        }
    }
    
    func fetchLeaderBoard(completionHandler: @escaping(Bool) -> Void){
        print("PRINTING BY SCORE")
        let ref = Database.database().reference()
        let usersinorder = ref.child("Users").queryOrdered(byChild: "todaysTime")
        
        usersinorder.observeSingleEvent(of: .value, with:{ (snapshot: DataSnapshot) in
            
            self.myTimes = []
            self.myArray = []
    
            var i = 1
            var foundIndex = -1
            for snap in snapshot.children {
                
                if((snap as! DataSnapshot).key == UIDevice.current.identifierForVendor?.uuidString){
                    print("FOUND USER")
                    foundIndex = i
                }
                else{
                    print("DID NOT FIND USER")
                    self.positionTitleLabel.isHidden = true
                }
                let userDict = (snap as! DataSnapshot).value as? NSDictionary
                let username = userDict?["username"] as? String ?? "NA"
                let score = userDict?["todaysTime"] as? String ?? "NA"
                if(score != ""){
                    self.myArray.append(String(username))
                    self.myTimes.append(String(score))
                }
                else{
                    foundIndex = -1
                }
                i += 1
            }
            if (foundIndex > 0) {
                self.positionTitleLabel.isHidden = false
            }
            
            completionHandler(true)
        })
        { error in
            print(error.localizedDescription)
            completionHandler(false)
        }
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
