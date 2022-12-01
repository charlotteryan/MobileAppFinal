//
//  LeaderboardViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
