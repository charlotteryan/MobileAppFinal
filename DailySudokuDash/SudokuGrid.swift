//
//  SudokuGrid.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/4/22.
//

import UIKit

class SudokuGrid: UIView {
    
    var gridOrigin = CGPoint() // in grid bounds
    var gridSize = 0.0
    
    // Modify to change line width
    let thinLine = 1.0
    let wideLine = 4.0
    
    // Draws the sudoku grid
    override func draw(_ rect: CGRect) {
        UIColor.label.setStroke() // set color so works in both light and dark modes
        
        // Horizontal lines
        for row in 0 ... 9 {
            let path = UIBezierPath()
            
            if (row==0 || row==3 || row==6 || row==9) {
                path.lineWidth = wideLine
            }
            else {
                path.lineWidth = thinLine
            }
            
            let start = CGPoint(x: gridOrigin.x, y: gridOrigin.y + (CGFloat(row) * gridSize/9))
            let finish = CGPoint(x: gridOrigin.x + gridSize, y: gridOrigin.y + (CGFloat(row) * gridSize/9))
            
            path.move(to: start)
            path.addLine(to: finish)
            path.stroke()
        }
        
        // Vertical lines
        for col in 0 ... 9 {
            let path = UIBezierPath()
            
            if (col==0 || col==3 || col==6 || col==9) {
                path.lineWidth = wideLine
            }
            else {
                path.lineWidth = thinLine
            }
            
            let start = CGPoint(x: gridOrigin.x  + (CGFloat(col) * gridSize/9), y: gridOrigin.y)
            let finish = CGPoint(x: gridOrigin.x + (CGFloat(col) * gridSize/9), y: gridOrigin.y + gridSize)
            
            path.move(to: start)
            path.addLine(to: finish)
            path.stroke()
        }
    }

}
