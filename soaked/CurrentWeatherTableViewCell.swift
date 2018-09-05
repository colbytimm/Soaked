//
//  CurrentWeatherTableViewCell.swift
//  soaked
//
//  Created by Colby Timm on 2018-09-01.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import UIKit

enum MainCellState {
    case expanded
    case collapsed
}

class CurrentWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var humidityLbl:UILabel!
    @IBOutlet weak var windLbl:UILabel!
    @IBOutlet weak var dewPointLbl:UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var airQualityLbl: UILabel!
    @IBOutlet weak var humidexLbl: UILabel!
    
    private var currentWeatherItemsDict: [String:String]?
    
    let currentWeatherItem = WeatherTableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.currentWeatherItemsDict = UserDefaults.standard.dictionary(forKey: "currentWeather") as? [String:String]
        
        if self.currentWeatherItemsDict != nil {
            for (key, value) in self.currentWeatherItemsDict! {
                switch key {
                case "Tendency" : if value == "" {pressureLbl?.text = "Pressure: -"} else {pressureLbl?.text = "Pressure:" + value}
                case "Humidity" : if value == "" {humidityLbl?.text = "Pressure: -"} else {humidityLbl?.text = "Humidity:" + value}
                case "Humidex" : if value == "" {humidexLbl?.text = "Pressure: -"} else {humidexLbl?.text = "Humidex:" + value}
                case "Dewpoint" : if value == "" {dewPointLbl?.text = "Pressure: -"} else {dewPointLbl?.text = "Dew Point:" + value}
                case "Wind" : if value == "" {windLbl?.text = "Pressure: -"} else {windLbl?.text = "Wind:" + value}
                case "Index" : print("hel" + value + "lo") //if value == "" {airQualityLbl?.text = "Pressure: -"} else {airQualityLbl?.text = "Air Quality:" + value}
                default : break
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
