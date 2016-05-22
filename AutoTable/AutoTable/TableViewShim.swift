//
//  TableViewRenderer.swift
//  AutoTable
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import UIKit

enum Changeset {
    case Add(NSIndexPath)
    case Delete(NSIndexPath)
    case RefreshOnly
}


struct CellTypeDefinition {
    let nibFilename: String
    let cellIdentifier: String
}

public final class TableViewShim: NSObject {

    var tableViewModel: TableViewModel!

    let cellTypes: [CellTypeDefinition]

    let tableView: UITableView

    var _cellsOnScreen: [IndexPathKey: UITableViewCell] = [:]

    init(cellTypes: [CellTypeDefinition], tableView: UITableView) {
        self.cellTypes = cellTypes
        self.tableView = tableView

        for cellType in cellTypes {
            let nibFile = UINib(nibName: cellType.cellIdentifier, bundle: nil)
            self.tableView.registerNib(nibFile, forCellReuseIdentifier: cellType.cellIdentifier)
        }

        super.init()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }


    func newViewModelWithChangeset(newViewModel: TableViewModel, changeSet: Changeset) {
        self.tableViewModel = newViewModel

        switch changeSet {
        case let .Delete(indexPath):
            self.tableView.deleteRowsAtIndexPaths(
                [indexPath],
                withRowAnimation: .Automatic
            )
        case let .Add(indexPath):
            self.tableView.insertRowsAtIndexPaths(
                [indexPath],
                withRowAnimation: .Automatic
            )
        case .RefreshOnly:
            for (indexPathKey, cell) in self._cellsOnScreen {
                self.tableViewModel?[indexPathKey.indexPath].applyViewModelToCell(cell)
            }
        }
    }

}

extension TableViewShim: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableViewModel.sections.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellViewModel = self.tableViewModel[indexPath]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellViewModel.cellIdentifier) ?? UITableViewCell()
        cellViewModel.applyViewModelToCell(cell)

        self._cellsOnScreen[indexPath.key] = cell

        return cell
    }

    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self._cellsOnScreen.removeValueForKey(indexPath.key)
    }


    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewModel.sections[section].cells.count
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableViewModel.sections[section].sectionHeaderTitle
    }

    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.tableViewModel.sections[section].sectionFooterTitle
    }

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.tableViewModel[indexPath].canEdit
    }

    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableViewModel[indexPath].commitEditingClosure?(indexPath)
    }

    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {

    }

}

//optional public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
//@available(iOS 2.0, *)
//optional public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
//
//// Data manipulation - insert and delete support
//
//// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
//@available(iOS 2.0, *)
//optional
//
//// Data manipulation - reorder / moving support
//
//@available(iOS 2.0, *)
