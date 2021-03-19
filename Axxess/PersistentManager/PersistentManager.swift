//
//  PersistentManager.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import Foundation
import RealmSwift

class PersistentManager {

    // MARK: - Properties

    static let shared = PersistentManager()

    let realm = try! Realm()

    func deleteAllItemsFromDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    // MARK: - Realm Actions

    func saveItemToDatabase(items : [Item]) {

        try! realm.write {
            for item in items {
                let realmInstance = RealmItem()
                realmInstance.id = item.id
                realmInstance.type = item.type.rawValue
                realmInstance.date = item.date
                realmInstance.data = item.data
                realm.add(realmInstance)
            }
        }
    }

    func getItemsFromDataBase() -> [Item] {

        let realmItems = realm.objects(RealmItem.self)

        var items = [Item]()

        for realItem in realmItems {
            let item = Item(id: realItem.id, type: ItemType(rawValue: realItem.type)!, date: realItem.date, data: realItem.data)

            items.append(item)
        }
        return items
    }

    // Save image to disk for offline usage

    func writeImageToLocalFile(image: UIImage, path: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(path)
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getImageFromFile(path: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(path).path
        
        guard FileManager.default.fileExists(atPath: filePath) else { return nil }
        return UIImage(contentsOfFile: filePath)!

    }
}
