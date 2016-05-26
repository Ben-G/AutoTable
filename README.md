#About

This repo demonstrates how UIKIt APIs can be wrapped with a declarative API layer. The `UITableView` API is used as an example.
The approach taken in this example allows us to describe table views in terms of simple data models instead of through implementation of `UITableViewDataSource` or `UITableViewDelegate`.
This makes the UI code is easier to read and less redundant.

##Example

Let's dive right into an example of how the declarative API can be used. This repo provides `TableViewModel`, `TableViewSectionModel` and `TableViewCellModel` to describe what a table view should look like. These types are simple structs.

Below you can see a function `tableViewModelForUserList` that creates a `TableViewModel` based on a list of users as input:

```swift
func tableViewModelForUserList(users: [User], deleteClosure: CommitEditingClosure) -> TableViewModel {
    return TableViewModel(sections: [
        TableViewSectionModel(cells:
            users.map { viewModelForUser($0, deleteClosure: deleteClosure) }
        )
    ])
}

func viewModelForUser(user: User, deleteClosure: CommitEditingClosure) -> TableViewCellModel {

	// updates the UITableViewCell to represent the data from the TableViewCellModel 
    func applyViewModelToCell(cell: UITableViewCell, user: Any) {
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
```

The `tableViewModelForUserList` creates a table with one section; within that section it creates an individual cell for each user by calling `viewModelForUser`. The beauty of this approach is that the description of the table view is created by pure functions that have a well defined input. This isolates the view code well from the rest of our application code and makes it easy to test that a certain input state results in a certain UI.

To display the `TableViewModel` on screen we need to provide it to a `TableViewShim` that implements the `UITableViewDataSource` and `UITableViewDelegate` methods for us:

```swift
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
```

##Updating the Table View



