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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchLeaderBoard()
        setupTableView()
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
    
    func fetchLeaderBoard(){
        print("PRINTING BY SCORE")
        let ref = Database.database().reference()
        let usersinorder = ref.child("LeaderBoard").queryOrdered(byChild: "Score").queryLimited(toFirst: 20)
        
        usersinorder.observe(.value, with:{ (snapshot: DataSnapshot) in
    
            for snap in snapshot.children {

                print((snap as! DataSnapshot).key)
                self.myArray.append((snap as! DataSnapshot).key)
                let scoreDict = (snap as! DataSnapshot).value as! NSDictionary
                let score = scoreDict["Score"] as? Int ?? 0
                print(score)
                self.myTimes.append(String(score))
            }
        })
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
