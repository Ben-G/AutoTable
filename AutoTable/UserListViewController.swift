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

    @IBAction func addUser(sender: AnyObject) {
        self.users.append(
            User(username: NSUUID().UUIDString)
        )

        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                users,
                deleteClosure: deleteUser
            ),
            changeSet: .Add(NSIndexPath(
                forRow: self.users.count - 1,
                inSection: 0
            ))
        )
    }

    func deleteUser(indexPath: NSIndexPath) {
        self.users.removeAtIndex(indexPath.row)

        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                users,
                deleteClosure: deleteUser
            ),
            changeSet: .Delete(indexPath)
        )
    }

    @IBAction func renameAll(sender: AnyObject) {
        self.users = self.users.map { _ in User(username: "New Name") }

        self.tableViewRenderer.newViewModelWithChangeset(
            tableViewModelForUserList(
                users,
                deleteClosure: deleteUser
            ),
            changeSet: .RefreshOnly
        )
    }

}
