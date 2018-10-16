//
//  MainWeatherTableViewCell.swift
//  soaked
//
//  Created by Colby Timm on 2018-09-04.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    @IBOutlet var backgroundImg: UIImageView!
    
    @IBOutlet weak var weatherTypeLbl:UILabel!
    @IBOutlet weak var cityLbl:UILabel!
    @IBOutlet weak var temperatureLbl:UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    private var currentWeatherItemsDict: [String:String]?
    
    let currentWeatherItem = WeatherTableViewController()
    var condition: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.currentWeatherItemsDict = UserDefaults.standard.dictionary(forKey: "currentWeather") as? [String:String]
        
        if self.currentWeatherItemsDict != nil {
            for (key, value) in self.currentWeatherItemsDict! {
                switch key {
                case "Condition" : condition = value
                case "Temperature" : temperatureLbl?.text = value.trimmingCharacters(in: .whitespaces) + "°"
                default : break
                }
            }
            weatherTypeLbl?.text = condition
            
            let sunset = 19
            let sunrise = 7
            
            let date = Date()
            let calendar = Calendar.current
            //let month = calendar.component(.month, from: date)
            let hour = calendar.component(.hour, from: date)
            //let minutes = calendar.component(.minute, from: date)
            
            // CHECK NIGHT
            if (hour >= sunset && hour <= sunrise) && isFall() {
                let image = UIImage(named: "fall_night_background")
                backgroundImg?.image = image
            }
            if (hour >= sunset && hour <= sunrise) && (condition?.lowercased().range(of: "cloud") != nil || condition?.lowercased().range(of: "cloudy") != nil) {
                let image = UIImage(named: "cloudy_night_background")
                backgroundImg?.image = image
            }
            if (hour >= sunset && hour <= sunrise) && (condition?.lowercased().range(of: "rain") != nil || condition?.lowercased().range(of: "raining") != nil) {
                let image = UIImage(named: "rain_night_background")
                backgroundImg?.image = image
            }
            if (hour >= sunset && hour <= sunrise) && (condition?.lowercased().range(of: "snow") != nil || condition?.lowercased().range(of: "snowing") != nil) {
                let image = UIImage(named: "snow_night_background")
                backgroundImg?.image = image
            }
            if (hour >= sunset && hour <= sunrise) {
                let image = UIImage(named: "clear_night_background")
                backgroundImg?.image = image
            }
            
            // CHECK DAY
            if isFall() {
                let image = UIImage(named: "fall_background")
                backgroundImg?.image = image
            }
            if condition?.lowercased().range(of: "cloud") != nil || condition?.lowercased().range(of: "cloudy") != nil {
                let image = UIImage(named: "cloudy_background")
                backgroundImg?.image = image
            }
            if condition?.lowercased().range(of: "rain") != nil || condition?.lowercased().range(of: "raining") != nil {
                let image = UIImage(named: "rain_background")
                backgroundImg?.image = image
            }
            if condition?.lowercased().range(of: "snow") != nil || condition?.lowercased().range(of: "snowing") != nil {
                let image = UIImage(named: "snow_background")
                backgroundImg?.image = image
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Sept 22 - March 20
    func isFall() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        if month >= 9 || month <= 3 {
            if month == 9 {
                if day >= 22 {
                    return true
                }
                else {
                    return false
                }
            }
            if month == 3 {
                if day <= 20 {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return true
            }
        }
        else {
            return false
        }
    }

}
