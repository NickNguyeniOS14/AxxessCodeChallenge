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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.002) {
                    self.updateViews(forItem: item)
                }
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

    override func prepareForReuse() {
        itemImageView.image = nil
    }
    
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
            case .image:

                // If item is image type, remove the textLabel and replace with an imageView.

                itemTextLabel.removeFromSuperview()
                
                addSubview(itemImageView)
                
                addItemImageViewContraints()
                
                idLabel.text = item.id
                
                dateLabel.text = item.date == "" ? "N/A" : item.date ?? "N/A"

                itemImageView.image = nil

                updateImageViewFor(item: item)

            default:
                
                /* If item is text or other type,
                 remove the imageView and replace with a label. */

                itemImageView.removeFromSuperview()
                
                addSubview(itemTextLabel)
                
                addItemTextLabelConstraints()
                
                itemTextLabel.text = item.data?.trunc(length: 100).trimmingCharacters(in: .whitespacesAndNewlines)
                
                idLabel.text = item.id
                
                dateLabel.text = item.date
        }
    }

    private func updateImageViewFor(item: Item) {
        // If this is second time launching the app, use offline image instead.
        if let localImage = item.offlineImage  {
            self.itemImageView.image = localImage
        } else if let urlString = item.data {
            // If this is the first time launching the app, download image from the Web.
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
                placeholder: placeHolderImage,
                transition: .fadeIn(duration: 0.4)
            )
            
            Nuke.loadImage(with: request,
                           options: options,
                           into: itemImageView) { response in
                switch response {
                    case .success(let imageResponse):
                        // Set itemImageView's image to the image that comes back from server and save to disk.
                        self.itemImageView.image = imageResponse.image
                        PersistentManager.shared.writeImageToLocalFile(image: imageResponse.image, path: item.id)
                    case .failure(let error):
                        // Log the bad URL error to debug.
                        print("NO URL IMAGE: \(error.localizedDescription)")
                }
            }
        }
    }
}
