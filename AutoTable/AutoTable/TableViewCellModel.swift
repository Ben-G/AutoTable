//
//  TableViewCellModel.swift
//  AutoTable
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

typealias CommitEditingClosure = (NSIndexPath) -> Void

struct TableViewCellModel {
    let cellIdentifier: String
    let canEdit: Bool
    let commitEditingClosure: CommitEditingClosure?
    let applyViewModelToCell: (UITableViewCell) -> Void

    init(
        cellIdentifier: String,
        applyViewModelToCell: (UITableViewCell) -> Void,
        commitEditingClosure: CommitEditingClosure? = nil
    ) {
        self.cellIdentifier = cellIdentifier
        self.applyViewModelToCell = applyViewModelToCell
        self.commitEditingClosure = commitEditingClosure
        self.canEdit = true
    }
}
