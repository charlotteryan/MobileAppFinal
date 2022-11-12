//
//  PuzzleViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit

class PuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sudokuGrid: SudokuGrid!
    
    var puzzleData: [GridSquare] = []
    
    var selectedCell: SudokuGridCell?
    
    var selectedNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Today's Game"
        setUpCollectionView()
        fetchPuzzleData()
        drawGrid()
    }
    
    // ***********************
    // *** STACK VIEW ***
    // ***********************
    
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    
    
    @IBAction func onePressed(_ sender: UIButton) {
        selectedNumber = "1"
        
        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)
        
        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            three.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func twoPressed(_ sender: UIButton) {
        selectedNumber = "2"
        
        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)
        
        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            one.backgroundColor = .clear
            three.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    
    @IBAction func threePressed(_ sender: UIButton) {
        
        selectedNumber = "3"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func fourPressed(_ sender: UIButton) {
        selectedNumber = "4"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            three.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func fivePressed(_ sender: UIButton) {
        selectedNumber = "5"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            three.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func sixPressed(_ sender: UIButton) {
        selectedNumber = "6"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            three.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func sevenPressed(_ sender: UIButton) {
        selectedNumber = "7"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            three.backgroundColor = .clear
            eight.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func eightPressed(_ sender: UIButton) {
        selectedNumber = "8"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            three.backgroundColor = .clear
            nine.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    @IBAction func ninePressed(_ sender: UIButton) {
        selectedNumber = "9"

        print("titleLabel")
        print(sender.titleLabel!.text!)
        print("selectedNumber: ")
        print(selectedNumber!)

        if sender.titleLabel!.text! == selectedNumber {
            sender.backgroundColor = UIColor(red: 255, green: 255, blue: 0, alpha: 0.5)
            print("background should be yellow")
            two.backgroundColor = .clear
            one.backgroundColor = .clear
            four.backgroundColor = .clear
            five.backgroundColor = .clear
            six.backgroundColor = .clear
            seven.backgroundColor = .clear
            eight.backgroundColor = .clear
            three.backgroundColor = .clear
        }
        else {
            sender.backgroundColor = .clear
            print("not equal")
        }
    }
    
    
    
    
    
    
    // ***********************
    // *** COLLECTION VIEW ***
    // ***********************
    
    // Returns the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81 // 9x9 grid
    }
    
    // Get cell at a given point
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SudokuGridCell
        
        // TODO: load grid with puzzle info
        let cellData = puzzleData[indexPath.row]
        if let val = cellData.value {
            cell.numberLabel.text = String(val)
        }
        if (!cellData.canEdit) {
            cell.numberLabel.textColor = UIColor.blue
        }
        
        return cell
    }
    
    // Selected a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisCell = collectionView.cellForItem(at: indexPath) as! SudokuGridCell
        
        // highlight selected cell
        thisCell.backgroundColor = UIColor(red: 0.4902, green: 0.7451, blue: 0.9294, alpha: 1.0) /* light blue */
        
        if let pastSelected = selectedCell {
            if (pastSelected == thisCell) {
                return
            }
            // clear past cell highlight
            pastSelected.backgroundColor = UIColor.clear
        }
        
        selectedCell = thisCell
    }
    
    // https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started#toc-anchor-013
    // Tells the layout the size of a given cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = collectionView.frame.width / 9
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // ************
    // *** MISC ***
    // ************
    
    func drawGrid() {
        sudokuGrid.gridOrigin = collectionView.convert(collectionView.bounds.origin, to: sudokuGrid)
        sudokuGrid.gridSize = collectionView.frame.width
    }
    
    func fetchPuzzleData() {
        let g1 = GridSquare(value: nil, canEdit: true)
        let g2 = GridSquare(value: 5, canEdit: false)
        let g3 = GridSquare(value: 7, canEdit: false)
        // TODO: currently, just creating empty sudoku grid
        for _ in 1 ... 27 {
            puzzleData.append(g1)
            puzzleData.append(g2)
            puzzleData.append(g3)
        }
    }
}
