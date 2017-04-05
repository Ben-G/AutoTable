//
//  TableViewModel.swift
//  AutoTable
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct TableViewModel {

    var editingMode: Bool = false
    let sections: [TableViewSectionModel]

    init(sections: [TableViewSectionModel]) {
        self.sections = sections
    }

    subscript(indexPath: IndexPath) -> TableViewCellModel {
        return self.sections[indexPath.section].cells[indexPath.row]
    }
}
