//
//  PuzzleModel.swift
//  DailySudokuDash
//
//  Created by Madeline Brooks on 11/5/22.
//

import Foundation

struct GridSquare {
    var value: Int?
    var solvedValue: Int
    let canEdit: Bool
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    var noteField: [String] = ["", "", "", "", "", "", "", "", ""]
}
