//
//  TableViewCellModel.swift
//  AutoTable
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

typealias CommitEditingClosure = (IndexPath) -> Void

struct TableViewCellModel {
    let cellIdentifier: String
    let canEdit: Bool
    let commitEditingClosure: CommitEditingClosure?
    let applyViewModelToCell: (UITableViewCell, Any) -> Void
    let customData: Any

    init(
        cellIdentifier: String,
        applyViewModelToCell: @escaping (UITableViewCell, Any) -> Void,
        commitEditingClosure: CommitEditingClosure? = nil,
        customData: Any
    ) {
        self.cellIdentifier = cellIdentifier
        self.applyViewModelToCell = applyViewModelToCell
        self.commitEditingClosure = commitEditingClosure
        self.canEdit = true
        self.customData = customData
    }
}

extension TableViewCellModel {
    func applyViewModelToCell(_ cell: UITableViewCell) {
        self.applyViewModelToCell(cell, self.customData)
    }
}
