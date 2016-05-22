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

    let tableViewRenderer: TableViewRenderer!

    var users: [User] = [
        User(username: "A"),
        User(username: "B"),
        User(username: "C"),
        User(username: "D")
    ]

    init() {
        self.tableViewRenderer = TableViewRenderer(cellTypes: [
            CellTypeDefinition(
                nibFilename: "UserCell",
                cellIdentifier: "UserCell"
            )
        ])

        super.init(nibName: nil, bundle: nil)

        self.tableViewRenderer.tableViewModel = tableViewModelForUserList(
            users,
            deleteClosure: deleteUser
        )
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        self.tableViewRenderer.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tableViewRenderer.frame = self.view.bounds

        self.view.addSubview(self.tableViewRenderer)
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
                forRow: self.users.count,
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

    

}
