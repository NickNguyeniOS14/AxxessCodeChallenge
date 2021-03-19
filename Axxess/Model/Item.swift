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
    var type: String
    var date: String?
    var data: String?
}
extension Item {
    var image: UIImage? {
        return PersistentManager.shared.getImageFromFile(path: id)
    }
}

class RealmItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var date: String? = nil
    @objc dynamic var data: String? = nil

}
extension RealmItem {
    var image: UIImage? {
        return PersistentManager.shared.getImageFromFile(path: id)
    }
}
