//
//  Item.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import Foundation
import RealmSwift

struct Item: Codable {
    var id: String
    var type: ItemType
    var date: String?
    var data: String?
}

enum ItemType: String, CaseIterable, Codable {
    case text
    case image
    case other
}

extension Item {
    var offlineImage: UIImage? {
        return PersistentManager.shared.getImageFromFile(path: id)
    }
}

// Realm Objects

class RealmItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var date: String? = nil
    @objc dynamic var data: String? = nil
}
