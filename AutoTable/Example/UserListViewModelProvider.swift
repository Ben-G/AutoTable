//
//  XViewModelProvider.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

func tableViewModelForUserList(users: [User]) -> TableViewModel {
    return TableViewModel(sections: [
        TableViewSectionModel(cells: users.map(viewModelForUser))
    ])
}

func viewModelForUser(user: User) -> TableViewCellModel {

    func applyViewModelToCell(cell: UITableViewCell) {
        guard let cell = cell as? UserCell else { return }
        cell.nameLabel.text = user.username
    }

    func commitEditingClosure(indexPath: NSIndexPath) {
//        actionHandler.deleteUser(indexPath)
        print(indexPath)
    }

    return TableViewCellModel(
        cellIdentifier: "UserCell",
        applyViewModelToCell: applyViewModelToCell,
        commitEditingClosure: commitEditingClosure
    )
}
