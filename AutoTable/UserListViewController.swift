//
//  ViewController.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var tableViewRenderer: TableViewShim!

    var cellsOnScreen: [IndexPathKey: UITableViewCell] = [:]

    var users: [User] = [
        User(username: "A"),
        User(username: "B"),
        User(username: "C"),
        User(username: "D")
    ]

    override func viewDidLoad() {
        self.tableViewRenderer = TableViewShim(cellTypes: [
            CellTypeDefinition(
                nibFilename: "UserCell",
                cellIdentifier: "UserCell"
            )], tableView: tableView)

        self.tableViewRenderer.tableViewModel = tableViewModelForUserList(
            users,
            deleteClosure: deleteUser
        )
    }

    // MARK: Table Changes

    @IBAction func addUser(_ sender: AnyObject) {
        // Update underlying data source
        self.users.append(
            User(username: UUID().uuidString)
        )

        // Update UI
        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                users,
                deleteClosure: deleteUser
            ),
            changeSet: .add(IndexPath(
                row: self.users.count - 1,
                section: 0
            ))
        )
    }

    func deleteUser(_ indexPath: IndexPath) {
        self.users.remove(at: indexPath.row)

        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                users,
                deleteClosure: deleteUser
            ),
            changeSet: .delete(indexPath)
        )
    }

    @IBAction func renameAll(_ sender: AnyObject) {
        self.users = self.users.map { _ in User(username: "New Name") }

        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                self.users,
                deleteClosure: deleteUser
            ),
            changeSet: .refreshOnly
        )
    }

}
