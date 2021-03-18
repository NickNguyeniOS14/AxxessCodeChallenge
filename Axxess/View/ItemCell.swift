//
//  ItemCell.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import SnapKit
import UIKit
import Nuke

class ItemCell: UITableViewCell {

    // MARK: - Properties

    var item: Item? {
        didSet {
            if let item = item {
                updateViews(forItem: item)
            }
        }
    }

    static let cellIdentifier = "Item-Cell"

    private lazy var itemTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        addSubview(itemTextLabel)
        addSubview(idLabel)
        addSubview(itemImageView)
        addSubview(itemTextLabel)
        addSubview(dateLabel)
//        addSubview(itemImageView)


        itemTextLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.centerY.equalTo(snp.centerY)
        }
        itemImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
        }

        idLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(snp.top)
            make.width.equalTo(100)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(snp.trailing)
            make.top.equalTo(snp.top)
            make.width.equalTo(100)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action

    func updateViews(forItem item: Item) {
        switch item.type {
            case ItemStore.ItemType.image.rawValue:

                itemTextLabel.removeFromSuperview()
                addSubview(itemImageView)


                itemImageView.snp.makeConstraints { (make) in
                    make.leading.equalTo(snp.leading)
                    make.trailing.equalTo(snp.trailing)
                    make.top.equalTo(snp.top)
                    make.bottom.equalTo(snp.bottom)
                }

                idLabel.text = item.id
                dateLabel.text = item.date

                if let urlString = item.data {
                    let url = URL(string: urlString)!
                    Nuke.loadImage(with: url.usingHTTPS!, into: itemImageView)
                }

            default:

                itemImageView.removeFromSuperview()
                addSubview(itemTextLabel)
                itemTextLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(snp.leading)
                    make.trailing.equalTo(snp.trailing)
                    make.centerY.equalTo(snp.centerY)
                }

                itemTextLabel.text = item.data?.trunc(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)
                idLabel.text = item.id
                dateLabel.text = item.date
        }

    }
}
