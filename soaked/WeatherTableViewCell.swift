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

    @IBOutlet var conditionImg: UIImageView?
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
                
                // Set condition images for each cell
                if (condition?.lowercased().range(of: "cloud") != nil || condition?.lowercased().range(of: "cloudy") != nil) && title?.lowercased().range(of: "night") != nil {
                    let image: UIImage = UIImage(named: "cloudy_night")!
                    conditionImg?.image = image
                }
                if title?.lowercased().range(of: "night") == nil && condition?.lowercased().range(of: "sun") == nil && (condition?.lowercased().range(of: "cloud") != nil || condition?.lowercased().range(of: "cloudy") != nil) {
                    let image = UIImage(named: "cloudy")
                    conditionImg?.image = image
                }
                if condition?.lowercased().range(of: "sun") != nil && (condition?.lowercased().range(of: "cloud") != nil || condition?.lowercased().range(of: "cloudy") != nil) {
                    let image = UIImage(named: "partly_cloudy")
                    conditionImg?.image = image
                }
                if title?.lowercased().range(of: "night") != nil && condition?.lowercased().range(of: "clear") != nil {
                    let image = UIImage(named: "clear_night")
                    conditionImg?.image = image
                }
                if (condition?.lowercased().range(of: "rain") != nil || condition?.lowercased().range(of: "rainy") != nil) && title?.lowercased().range(of: "night") != nil {
                    let image: UIImage = UIImage(named: "rain_night")!
                    conditionImg?.image = image
                }
                if condition?.lowercased().range(of: "rain") != nil || condition?.lowercased().range(of: "rainy") != nil {
                    let image = UIImage(named: "rain")
                    conditionImg?.image = image
                }
                if (condition?.lowercased().range(of: "lightning") != nil || condition?.lowercased().range(of: "rain") != nil) {
                    let image: UIImage = UIImage(named: "lightning_rain")!
                    conditionImg?.image = image
                }
                if condition?.lowercased().range(of: "lightning") != nil {
                    let image = UIImage(named: "lightning")
                    conditionImg?.image = image
                }
                if (condition?.lowercased().range(of: "snow") != nil || condition?.lowercased().range(of: "snowing") != nil) && title?.lowercased().range(of: "night") != nil {
                    let image: UIImage = UIImage(named: "snow_night")!
                    conditionImg?.image = image
                }
                if condition?.lowercased().range(of: "snow") != nil || condition?.lowercased().range(of: "snowing") != nil {
                    let image = UIImage(named: "snow")
                    conditionImg?.image = image
                }
            }
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
