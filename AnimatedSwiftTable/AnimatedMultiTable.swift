//
//  AnimatedMultiTable.swift
//  AnimatedSwiftTable
//
//  Created by Bradley Hilton on 2/19/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import SwiftTable
import OrderedObjectSet
import Changeset

struct ClassContainer : Equatable {
    let value: AnyObject
}

func ==(lhs: ClassContainer, rhs: ClassContainer) -> Bool {
    return lhs.value === rhs.value
}

private var tablesKey = "tables"

public protocol AnimatedMultiTable : MultiTable {}

extension AnimatedMultiTable {
    
    public var tables: OrderedObjectSet<TableSource> {
        get {
            guard let tables = objc_getAssociatedObject(self, &tablesKey) as? OrderedObjectSet<TableSource> else {
                return []
            }
            return tables
        }
        set {
            guard tables != newValue else { return }
            tables.filter { table in !newValue.contains { $0 === table } }.forEach { $0.parent = nil }
            newValue.forEach { $0.parent = self }
            let edits = Changeset.edits(from: tables.map { ClassContainer(value: $0) }, to: newValue.map { ClassContainer(value: $0) })
            parent?.beginUpdates()
            for edit in edits {
                guard let table = edit.value.value as? TableSource else {
                    continue
                }
                switch edit.operation {
                case .insertion:
                    parent?.insertSections(sectionsForTable(table, inTables: newValue), inTable: self, withRowAnimation: .fade)
                case .deletion:
                    parent?.deleteSections(sectionsForTable(table, inTables: tables), inTable: self, withRowAnimation: .fade)
                case .substitution:
                    parent?.reloadSections(sectionsForTable(table, inTables: tables), inTable: self, withRowAnimation: .fade)
                case .move(origin: _):
                    parent?.deleteSections(sectionsForTable(table, inTables: tables), inTable: self, withRowAnimation: .fade)
                    parent?.insertSections(sectionsForTable(table, inTables: newValue), inTable: self, withRowAnimation: .fade)
                }
            }
            objc_setAssociatedObject(self, &tablesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            parent?.endUpdates()
        }
    }
    
    func sectionsForTable(_ table: TableSource, inTables tables: OrderedObjectSet<TableSource>) -> IndexSet {
        var index = 0
        for t in tables {
            if t === table {
                return IndexSet(integersIn: index..<index+table.numberOfSections)
            } else {
                index += t.numberOfSections
            }
        }
        return IndexSet()
    }
    
}


