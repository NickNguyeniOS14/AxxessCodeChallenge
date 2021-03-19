//
//  ModelController.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import Foundation
import Alamofire

class ItemStore {

    // MARK: - Properties

    private let endpoint = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"

    var items = [Item]()

    var segmentedItems: [String] {
        return ItemType.allCases.map {
            $0.rawValue.capitalized
        }
    }

    var itemsWithText: [Item] {
        return items.filter {
            $0.type == .text &&
            $0.data != nil &&
            $0.data != String()
        }
    }

    var itemsWithImage: [Item] {
        return items.filter {
            $0.type == .image &&
            $0.data != nil
        }
    }

    var otherItems: [Item] {
        return items.filter {
            $0.type == .other
        }
    }

    // MARK: - Action
    
    func getItems(completion: @escaping (Result<[Item],NetworkError>) -> Void) {

        AF.request(endpoint, method: .get).responseJSON { response in
            guard let itemsData = response.data else {
                completion(.failure(.badResponse))
              return
            }
            do {
                let decoder = JSONDecoder()
                let itemsFromServer = try decoder.decode([Item].self, from: itemsData)
                self.items = itemsFromServer
                PersistentManager.shared.saveItemToDatabase(items: itemsFromServer)
                DispatchQueue.main.async {
                    completion(.success(itemsFromServer))
                }
            } catch {
                completion(.failure(.noData))
            }
        }
    }
}
