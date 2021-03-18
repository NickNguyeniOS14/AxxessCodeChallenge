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
        let segmentedItems = ItemStore.ItemType.allCases.map { $0.rawValue.uppercased() }
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
            self.tableView.reloadData()
        }
    }

    func setUpUI() {
        navigationItem.title = "Axxess"
        tableView.tableHeaderView = segmentedControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellIdentifier)
        tableView.rowHeight = 200
        tableView.tableFooterView = UIView()
    }


    @objc func switchSegmentControl(item: UISegmentedControl) {
        print(item.selectedSegmentIndex)
        tableView.reloadData()
    }

    // MARK: - Table View DataSource & Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return itemStore.itemsWithText.count
            case 1:
                return itemStore.itemsWithImage.count
            default:
                return itemStore.otherItems.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.cellIdentifier, for: indexPath) as! ItemCell

        cell.item = getItem(for: indexPath)

        return cell
    }

    // MARK: - Helper function

    func getItem(for indexPath: IndexPath) -> Item {
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

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
