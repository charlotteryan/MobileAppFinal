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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        fetchPuzzleData()
        drawGrid()
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
