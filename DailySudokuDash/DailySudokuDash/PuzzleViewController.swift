//
//  PuzzleViewController.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/2/22.
//

import UIKit
import Firebase

class PuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sudokuGrid: SudokuGrid!
    
    @IBOutlet weak var timerLabel: UILabel!
    var timer:Timer = Timer()
    var minutes:Int = 0
    var seconds:Int = 0
    
    var puzzleData: [GridSquare] = []
    var selectedCellPath: IndexPath?
    var highlightedCells: [Int] = []
    
    var fromHome = true // Tells us where to return after we win
    var viewTitle = "Puzzle"
    var dailyPuzzleVC = false
    
    var unsolvedBoard = ".23458679456179238789236145241365897367892451895714362632987514578641923914523786" // default board -- replace in fetch data
    var solvedBoard = "123458679456179238789236145241365897367892451895714362632987514578641923914523786"
    
    var notesMode = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = viewTitle
        setUpCollectionView()
        readPuzzleData()
        drawGrid()
        createTimer()
        highlightNearbyCells()
    }
    
    // ***********************
    // *** TIMER ***
    // ***********************
    func createTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: true
        )
    }
    @objc func fireTimer() {

        if seconds+1 == 60 {
            minutes+=1
            seconds = 0
        }
        else {
            seconds+=1
        }
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
        timerLabel.text = stringMin + " : " + stringSec
    }
    
    // ADD TIME + FLASHES RED
    func addTime() {
        minutes += 1
        self.timerLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            // perform your task here...
            print("Async after 3 seconds")
            self.timerLabel.textColor = .black
        })
    }
    
    // *********************
    // *** MODIFY PUZZLE ***
    // *********************
    
    @IBAction func selectedNumber(_ sender: UIButton) {
        guard let numLabel = sender.titleLabel,
              let numText = numLabel.text,
              let num = Int(numText),
              let selectedCellPath = selectedCellPath
        else {
            return
        }
        
        if(!puzzleData[selectedCellPath.row].canEdit) {
            return // do not edit provided cells
        }
        
        if (!notesMode) { // normal editing mode
            if (puzzleData[selectedCellPath.row].value == num) {
                puzzleData[selectedCellPath.row].value = nil // erase the cell
            }
            else {
                puzzleData[selectedCellPath.row].value = num
            }
            puzzleData[selectedCellPath.row].noteField = ["", "", "", "", "", "", "", "", ""]
        }
        else {
            puzzleData[selectedCellPath.row].value = nil
            if (puzzleData[selectedCellPath.row].noteField[num-1] == numText) {
                puzzleData[selectedCellPath.row].noteField[num-1] = ""
            }
            else {
                puzzleData[selectedCellPath.row].noteField[num-1] = numText
            }
            
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [selectedCellPath])
            }
        }
    
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    
    // Erase any value or notes inside the selected cell
    @IBAction func eraseCell() {
        guard let selectedCellPath = selectedCellPath else {
            return
        }
        if (puzzleData[selectedCellPath.row].canEdit) {
            puzzleData[selectedCellPath.row].value = nil
            puzzleData[selectedCellPath.row].noteField = ["", "", "", "", "", "", "", "", ""]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // Turn notes mode on and off
    @IBAction func changeNotesMode(_ sender: UIButton) {
        notesMode = !notesMode
        // update button
        if (notesMode) {sender.setTitle("Notes (on)", for: .normal)}
        else {sender.setTitle("Notes (off)", for: .normal)}
    }
    
    // Erase the contents of all editable cells
    @IBAction func clearBoard() {
        for i in 0...puzzleData.count-1 {
            if (puzzleData[i].canEdit) {
                puzzleData[i].value = nil
                puzzleData[i].noteField = ["", "", "", "", "", "", "", "", ""]
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
        
        // set selected cell path if doesn't exist yet
        if (selectedCellPath == nil) {
            selectedCellPath = indexPath
            puzzleData[indexPath.row].isSelected = true
            highlightNearbyCells()
        }
        
        // Find the value of the currently selected cell for highlighting
        var currentSelectedValue = 0
        if let selectedCellPath = selectedCellPath {
            let actualVal = puzzleData[selectedCellPath.row].value
            if (actualVal != nil) {
                currentSelectedValue = actualVal ?? 0 // don't care if null value
            }
        }
        
        let cellData = puzzleData[indexPath.row]

        if let val = cellData.value {cell.numberLabel.text = String(val)}
        else {cell.numberLabel.text = ""}
        
        if (!cellData.canEdit) {cell.numberLabel.textColor = UIColor.black}
        else {cell.numberLabel.textColor = UIColor.blue}
        
        if (cellData.isSelected) {
            cell.backgroundColor = UIColor(red: 0.4902, green: 0.7451, blue: 0.9294, alpha: 1.0) /* light blue */
        }
        else if (cellData.value == currentSelectedValue) {
            cell.backgroundColor = UIColor(red: 0.5686, green: 0.5686, blue: 0.5686, alpha: 1.0) /* darker grey */
        }
        else if (cellData.isHighlighted) {
            cell.backgroundColor = UIColor(red: 0.7569, green: 0.7569, blue: 0.7569, alpha: 1.0) /* light grey */
        }
        else {cell.backgroundColor = UIColor.clear}
        
        // note labels
        cell.note1.text = cellData.noteField[0]
        cell.note2.text = cellData.noteField[1]
        cell.note3.text = cellData.noteField[2]
        cell.note4.text = cellData.noteField[3]
        cell.note5.text = cellData.noteField[4]
        cell.note6.text = cellData.noteField[5]
        cell.note7.text = cellData.noteField[6]
        cell.note8.text = cellData.noteField[7]
        cell.note9.text = cellData.noteField[8]
        
        return cell
    }
    
    // Selected a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pastSelectedPath = selectedCellPath
        else {
            return
        }
        
        // if tap currently selected cell, don't change anything
        if (pastSelectedPath == indexPath) {
            return
        }
        
        // past selected is unselected, new is selcted
        puzzleData[pastSelectedPath.row].isSelected = false
        puzzleData[indexPath.row].isSelected = true
        
        // reload the cell appearance
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [pastSelectedPath])
            collectionView.reloadItems(at: [indexPath])
        }
        
        // update cells
        selectedCellPath = indexPath
        
        highlightNearbyCells()
    }
    
    // Highlight the cells in the selected row, column, and square
    func highlightNearbyCells() {
        print("highlighting")
        // unhighlight any currently highlighted cells
        for i in highlightedCells {
            puzzleData[i].isHighlighted = false
        }
        highlightedCells.removeAll()
        // remove from puzzle data first
        
        guard let selectedCellPath = selectedCellPath else {
            print("no selected cell")
            return
        }
        print("start finding cells to highlight")
        let selectedIndex = selectedCellPath.row
        let row = (selectedIndex / 9)
        let col = selectedIndex % 9
        
        // append highlighted indices to array
        for i in 0...8 {
            highlightedCells.append(row*9 + i) // row
            highlightedCells.append(9*i + col) // col
        }
        // squares
        let squareRow = (row/3)*3
        let squareCol = (col/3)*3
        for i in 0...2 {
            for j in 0...2 {
                highlightedCells.append(9*(squareRow+i) + squareCol + j)
            }
        }
        
        // modify puzzle data
        for i in highlightedCells {
            puzzleData[i].isHighlighted = true
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
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
    
    // ******************
    // *** MISC SETUP ***
    // ******************
    
    func drawGrid() {
        sudokuGrid.gridOrigin = collectionView.convert(collectionView.bounds.origin, to: sudokuGrid)
        sudokuGrid.gridSize = collectionView.frame.width
    }
    
    func readPuzzleData() {
        print("In puzzle is \(unsolvedBoard)")
        let boardData = zip(unsolvedBoard, solvedBoard)
        for (unsolved, solved) in boardData {
            if let solvedVal = solved.wholeNumberValue {
                if (unsolved == ".") {
                    puzzleData.append(GridSquare(value: nil, solvedValue: solvedVal, canEdit: true))
                }
                else {
                    puzzleData.append(GridSquare(value: solvedVal, solvedValue: solvedVal, canEdit: false))
                }
            }
        }
    }
    
    // Check if puzzle solution is correct
    @IBAction func checkBoard(_ sender: Any) {
        for i in 0...puzzleData.count-1 {
            if (puzzleData[i].value != puzzleData[i].solvedValue) {
                // TODO: add penalty + message on screen
                print("incorrect board")
                return
            }
        
        }
        
        self.performSegue(withIdentifier: "puzzleToWin", sender: sender)
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var winTime = ""
        if (segue.identifier == "puzzleToWin") {
            guard let winVC = segue.destination as? WinViewController else {return}
            
            // Convert seconds and minutes into strings
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
            winVC.time = "\(stringMin):\(stringSec)"
            winTime = "\(stringMin):\(stringSec)"
            
            // Tell win screen if from homepage or past puzzles
            winVC.fromHome = self.fromHome
        }
        
        //Adding User to leaderBoard
        if(dailyPuzzleVC){
            let username = UserDefaults.standard.string(forKey: "Username") ?? "sudokDEFAULT"
            ref.child("LeaderBoard").child(username).setValue(["Score": winTime])
        }
    }
    
    
}
