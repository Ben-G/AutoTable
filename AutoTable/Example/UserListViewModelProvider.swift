//
//  XViewModelProvider.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

func tableViewModelForUserList(users: [User], deleteClosure: CommitEditingClosure) -> TableViewModel {
    return TableViewModel(sections: [
        TableViewSectionModel(cells:
            users.map { viewModelForUser($0, deleteClosure: deleteClosure) }
        )
    ])
}

func viewModelForUser(user: User, deleteClosure: CommitEditingClosure) -> TableViewCellModel {

    func applyViewModelToCell(cell: UITableViewCell) {
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user.username
    }

    return TableViewCellModel(
        cellIdentifier: "UserCell",
        applyViewModelToCell: applyViewModelToCell,
        commitEditingClosure: deleteClosure
    )
}
