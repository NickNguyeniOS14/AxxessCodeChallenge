//
//  DetailViewController.swift
//  Axxess
//
//  Created by Nick Nguyen on 3/18/21.
//

import UIKit
import SnapKit
import Nuke

class DetailViewController: UIViewController {

    // MARK: - Properties

    var item: Item?

    lazy var itemTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.backgroundColor = .systemGray6
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()

     lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

     lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()

     lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(itemTextView)
        view.addSubview(dateLabel)
        view.addSubview(idLabel)
        view.addSubview(itemImageView)

        itemImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }

        dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(100)
        }

        idLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(100)
        }

        itemTextView.text = item?.data?.trimmingCharacters(in: .whitespacesAndNewlines)
        dateLabel.text = item?.date == "" ? "N/A" : item?.date ?? "N/A"
        idLabel.text = item?.id
        itemImageView.image = item?.offlineImage ?? placeHolderImage
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if item?.type == .text || item?.type == .other {
            itemImageView.removeFromSuperview()
            itemTextView.snp.makeConstraints { (make) in
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
                make.width.equalTo(view.frame.width)
                make.height.equalTo(300)
            }
        }
    }
}

