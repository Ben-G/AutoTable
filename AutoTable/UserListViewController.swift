//
//  ViewController.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    let tableViewRenderer: TableViewRenderer

    init(users: [User]) {
        self.tableViewRenderer = TableViewRenderer(cellTypes: [
            CellTypeDefinition(
                nibFilename: "UserCell",
                cellIdentifier: "UserCell"
            )
        ])

        self.tableViewRenderer.tableViewModel = tableViewModelForUserList(users)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.tableViewRenderer.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tableViewRenderer.frame = self.view.bounds

        self.view.addSubview(self.tableViewRenderer)
    }

}
