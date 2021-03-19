//
//  ViewController.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import UIKit
import SnapKit
import Alamofire
import RealmSwift
import Nuke

class HomeViewController: UITableViewController {

    // MARK: - Properties

    let itemStore = ItemStore()

    lazy var segmentedControl: UISegmentedControl = {
        let segmentedItems = ItemType.allCases.map { $0.rawValue.capitalized }
        let sc = UISegmentedControl(items: segmentedItems)
        sc.addTarget(self, action: #selector(switchSegmentControl), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

        itemStore.getItems { result in
            switch result {
                case .success:
                    print("SUCCESS")

                case .failure(let error):
                    print(" > >>>>> FAILURE: \(error.localizedDescription)")
                    self.itemStore.items = PersistentManager.shared.getItemsFromDataBase()
            }
            print(self.itemStore.items.count)
            
            self.tableView.reloadData()

        }
    }

    // MARK: - Table View DataSource & Delegate

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return itemStore.itemsWithText.count
            case 1:
                return itemStore.itemsWithImage.count
            default:
                return itemStore.otherItems.count
        }
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.cellIdentifier,for: indexPath) as! ItemCell
        cell.item = getItem(at: indexPath)
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = getItem(at: indexPath)
        let detailVC = DetailViewController()
        detailVC.item = selectedItem
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Actions

    private func setUpUI() {
        navigationItem.title = "Axxess"
        tableView.tableHeaderView = segmentedControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellIdentifier)
        tableView.rowHeight = 300
        tableView.tableFooterView = UIView()
    }

    private func getItem(at indexPath: IndexPath) -> Item {
        let item: Item
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                item = itemStore.itemsWithText[indexPath.row]
            case 1:
                item = itemStore.itemsWithImage[indexPath.row]
            default:
                item = itemStore.otherItems[indexPath.row]
        }
        return item
    }

    @objc func switchSegmentControl(segmentedControl: UISegmentedControl) {
        tableView.reloadData()
    }
}
