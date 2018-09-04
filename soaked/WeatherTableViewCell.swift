//
//  WeatherTableViewCell.swift
//  soaked
//
//  Created by Colby Timm on 2018-08-26.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var summaryLabel:UILabel! {
        didSet {
            summaryLabel.numberOfLines = 10
        }
    }
    @IBOutlet weak var dateLabel:UILabel!
    
    var item: WeatherItem! {
        didSet {
            titleLabel.text = item?.title
            summaryLabel.text = item?.summary
            dateLabel.text = item?.date
        }
    }

}
