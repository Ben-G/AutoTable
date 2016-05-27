#About

This repo demonstrates how UIKIt APIs can be wrapped with a declarative API layer. The `UITableView` API is used as an example.

⚠️ This repo represents an example, but isn't a library in itself. E.g. it currently does not include any tests. ⚠️

The approach taken in this example allows us to describe table views in terms of simple data models instead of through implementation of `UITableViewDataSource` or `UITableViewDelegate`.
This improves the UI code in several ways:
- It becomes easier to reason about
- It becomes less redundant
- It becomes easy to test

Using the wraper API from this repo table views can be described in terms of a pure function that produces a description of a table view based on well defined input data:

```swift
func tableViewModelForUserList(users: [User]) -> TableViewModel {
    return TableViewModel(sections: [
        TableViewSectionModel(cells:
            users.map { viewModelForUser($0) }
        )
    ])
}
```

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
```

The `tableViewModelForUserList` creates a table with one section; within that section it creates an individual cell for each user by calling `viewModelForUser`:

```swift
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

The beauty of this approach is that the description of the table view is created by pure functions that have a well defined input. This isolates the view code well from the rest of our application code and makes it easy to test that a certain input state results in a certain UI.

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

This setup code provides the `TableViewShim` with the definition of where to find the `UITableViewCells`, with a `UITableView` for which it should provide data and with a description of the `TableViewModel` that should be displayed.

With all this in place the table view content will be displayed on screen - without requiring us to implement a large amount of protocol requirements.

##Updating the Table View

Ideally we would simply assign a new `TableViewModel` to the `TableViewShim` in order to update the UI. In practice this requires quite some effort as we need to compare the old to the new model in order to detect & animate the changes. For this automatic, advanced approach check out [my expirement on a truly declarative UI layer that reacts automatically](https://github.com/Ben-G/UILib) which has support for an auto-updating table view.

For this simple API wrapper we provide the `TableViewShim` with a new `TableViewModel` whenever our state updates; but we also provide it with the details about which type of change occured so it doesn't need to derive this information itself.

Here's an example of how to add an entry to a user list:

```swift
@IBAction func addUser(sender: AnyObject) {
    // Update underlying data source
    self.users.append(
        User(username: NSUUID().UUIDString)
    )

    // Update UI
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
``` 

#Beyond This Example

It would be great to have a truly declarative view layer on top of UIKit that works like Facebook's [React](https://github.com/facebook/react) and automatically updates the UI whenever the description of the UI changes. I'm experimenting with this approach in the [UILib repository](https://github.com/Ben-G/UILib).
