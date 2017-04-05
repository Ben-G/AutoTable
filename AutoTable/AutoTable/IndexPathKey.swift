//
//  IndexPathKey.swift
//  AutoTable
//
//  Created by Benji Encz on 5/21/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

/**
 Provides guaruanteed implementation of `Hashable` for index paths and is therefore
 safe to use as a dictionary key. Using `NSIndexPath` as a dictionary key directly is
 problematic, as a `UITableView` will sometimes provide delegate methods with an instance of
 `NSMutableIndexPath` which will fail the equality test with `NSIndexPath`.
 The `key` extension on `NSIndexPath` provides a convenient way to initialize this type.
 */
struct IndexPathKey: Hashable {
    let row: Int
    let section: Int
    let hashValue: Int
    var indexPath: IndexPath { return IndexPath(row: self.row, section: self.section) }

    init(indexPath: IndexPath) {
        self.row = indexPath.row
        self.section = indexPath.section
        /*
         Since the hash value for different `NSIndexPath` subclasses might differ it is
         necessary to calculate our own hash value. This one guarantees collision free values
         for up to 100,000 sections.
         */
        self.hashValue = indexPath.row * 100000 + indexPath.section
    }
}

func == (lhs: IndexPathKey, rhs: IndexPathKey) -> Bool {
    return lhs.row == rhs.row && lhs.section == rhs.section
}

extension IndexPath {
    var key: IndexPathKey {
        return IndexPathKey(indexPath: self)
    }
}
