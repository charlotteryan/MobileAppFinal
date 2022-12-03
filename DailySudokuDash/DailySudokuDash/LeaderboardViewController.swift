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
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLeaderBoardData()
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
        let usersinorder = ref.child("LeaderBoard").queryOrdered(byChild: "Score").queryLimited(toFirst: 99)
        
        usersinorder.observeSingleEvent(of: .value, with:{ (snapshot: DataSnapshot) in
            
            self.myTimes = []
            self.myArray = []
    
            for snap in snapshot.children {

                print((snap as! DataSnapshot).key)
                self.myArray.append((snap as! DataSnapshot).key)
                let scoreDict = (snap as! DataSnapshot).value as? NSDictionary
                let score = scoreDict?["Score"] as? Int ?? 0
                print(score)
                self.myTimes.append(String(score))
            }
            
            
            
            
            completionHandler(true)
        })
        { error in
            print(error.localizedDescription)
            completionHandler(false)
        }
    }

    var myArray = ["Charlotte", "Madeline", "Ian", "Daniel", "Jake", "Lindsay", "Abby", "Mike", "James", "Brody", "Lydia"]
    var myTimes = ["0.57", "0.99", "1.31", "1.56", "2.13", "2.59", "3.10", "3.59", "12.50", "12.59", "15.10"]
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
