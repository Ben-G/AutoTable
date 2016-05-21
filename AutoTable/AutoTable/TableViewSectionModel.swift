//
//  TableViewSectionModel.swift
//  AutoTable
//
//  Created by Benji Encz on 4/29/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

struct TableViewSectionModel {

    let cells: [TableViewCellModel]

    let sectionHeaderTitle: String? = nil
    let sectionFooterTitle: String? = nil

    init(cells: [TableViewCellModel]) {
        self.cells = cells
    }

}
