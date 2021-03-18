//
//  ModelController.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import Foundation
import Alamofire

enum ItemType: String, CaseIterable {
    case text
    case image
    case other
}

class ItemStore {

    // MARK: - Properties

    private let endpoint = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"

    var items = [Item]()

    var sections: [String] {
        return items.map { $0.type }.uniques
    }

    var itemsWithText: [Item] {
        return items.filter { $0.type == ItemType.text.rawValue && $0.data != nil && $0.data != String() }
    }

    var itemsWithImage: [Item] {
        return items.filter { $0.type == ItemType.image.rawValue && $0.data != nil }
    }

    var otherItems: [Item] {
        return items.filter { $0.type == ItemType.other.rawValue }
    }

    // MARK: - Action
    
    func getItems(completion: @escaping (Result<[Item],NetworkError>) -> Void) {

        AF.request(endpoint, method: .get).responseJSON { response in
            guard let itemsData = response.data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([Item].self, from: itemsData)
                self.items = items
                
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                completion(.failure(.badResponse))
            }
        }
    }
}
