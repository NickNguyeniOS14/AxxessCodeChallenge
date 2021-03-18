//
//  ArrayUnique + Ext.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import Foundation

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for element in self {
            if !added.contains(element) {
                buffer.append(element)
                added.insert(element)
            }
        }
        return buffer
    }
}
