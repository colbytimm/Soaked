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
    
    private var currentWeatherItemsDict: [String:String]?
    //private var new = UserDefaults.standard.dictionary(forKey: "futureWeather")
    
    var item: WeatherItem! {
        didSet {
            if item?.title != nil {
                let title = item?.title
                let condition = item?.condition
                let highTemp = item?.highTemp
                let lowTemp = item?.lowTemp
                titleLabel.text = trimString(title: title!)
                conditionLbl.text = condition
                highTempLbl.text = highTemp
                lowTempLbl.text = lowTemp
            }
//            if item?.summary != nil {
//                summaryLabel.text = item?.summary
//            }
        }
    }
    
//    var futureItem: FutureWeatherItem! {
//        didSet {
//            if futureItem?.condition != nil {
//                conditionLbl.text = futureItem?.condition
//            }
//            if futureItem?.highTemp != nil {
//                highTempLbl.text = futureItem?.highTemp
//            }
//            if futureItem?.lowTemp != nil {
//                lowTempLbl.text = futureItem?.lowTemp
//            }
//        }
//    }
    
    func trimString(title: String) -> String {
        var str = title
        if let dotRange = str.range(of: ":") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        return str
    }

}
