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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(idLabel)
        addSubview(dateLabel)
        addSubview(itemImageView)
        addSubview(itemTextLabel)

        addItemTextLabelConstraints()
        addItemImageViewContraints()
        addLabelsContraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action

    func addItemTextLabelConstraints() {
        itemTextLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.centerY.equalTo(snp.centerY)
        }
    }

     private func addItemImageViewContraints() {

        itemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
    }

     private func addLabelsContraints() {
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

    private func updateViews(forItem item: Item) {
        switch item.type {
            case ItemType.image.rawValue:

                itemTextLabel.removeFromSuperview()
                
                addSubview(itemImageView)

                addItemImageViewContraints()

                idLabel.text = item.id

                dateLabel.text = item.date == "" ? "N/A" : item.date ?? "N/A"

                if let urlString = item.data {
                    let url = URL(string: urlString)!.usingHTTPS!

                    let request = ImageRequest(
                        url: url,
                        processors: [
                            ImageProcessors.Circle(),
                            ImageProcessors.Resize(size: itemImageView.bounds.size)
                        ],
                        priority: .high
                    )

                    let options = ImageLoadingOptions(
                        placeholder: UIImage(named: "404NoImage"),
                        transition: .fadeIn(duration: 0.4)
                    )

                    Nuke.loadImage(with: request, options: options, into: itemImageView) { response in
                        switch response {
                            case .success(let imageResponse):
                                self.itemImageView.image = imageResponse.image
                            case .failure(let error):
                                print(error)
                        }
                    }
                }

            default:

                itemImageView.removeFromSuperview()

                addSubview(itemTextLabel)

                addItemTextLabelConstraints()

                itemTextLabel.text = item.data?.trunc(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)

                idLabel.text = item.id
                
                dateLabel.text = item.date
        }
    }
}
