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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var highTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    @IBOutlet weak var summaryLabel: UILabel! {
        didSet {
            summaryLabel.numberOfLines = 4
        }
    }
    
    var tempDict: [String:String]?
    
    var item: WeatherItem! {
        didSet {
            if item?.title != nil {
                let title = item?.title
                titleLabel.text = trimString(title: title!)
            }
            if item?.summary != nil {
                summaryLabel.text = item?.summary
            }
        }
    }
    
    func trimString(title: String) -> String {
        var str = title
        if let dotRange = str.range(of: ":") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        return str
    }
    
    func getTemp(title: String) {
        var str = title
        
        if let dotRange = str.range(of: ".") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
            conditionLbl.text = str
        }
    }

}
