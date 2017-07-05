//
//  XViewModelProvider.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

func tableViewModelForUserList(_ users: [User], deleteClosure: @escaping CommitEditingClosure) -> TableViewModel {
    return TableViewModel(sections: [
        TableViewSectionModel(cells:
            users.map { viewModelForUser($0, deleteClosure: deleteClosure) }
        )
    ])
}

func viewModelForUser(_ user: User, deleteClosure: @escaping CommitEditingClosure) -> TableViewCellModel {

    func applyViewModelToCell(_ cell: UITableViewCell, user: Any) {
        guard let cell = cell as? UserCell else { return }
        guard let user = user as? User else { return }

        cell.nameLabel.text = user.username
    }

    return TableViewCellModel(
        cellIdentifier: "UserCell",
        applyViewModelToCell: applyViewModelToCell,
        commitEditingClosure: deleteClosure,
        customData: user
    )
}
