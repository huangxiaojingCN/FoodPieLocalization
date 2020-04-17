//
//  DiscoverRestaurantCell.swift
//  FoodPie
//
//  Created by ciggo on 4/17/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit

class DiscoverRestaurantCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }

    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.numberOfLines = 0
        }
    }

    @IBOutlet var locationLabel: UILabel! {
        didSet {
            locationLabel.numberOfLines = 0
        }
    }

    @IBOutlet var phoneLabel: UILabel! {
        didSet {
            phoneLabel.numberOfLines = 0
        }
    }

    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }

    @IBOutlet var headerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
