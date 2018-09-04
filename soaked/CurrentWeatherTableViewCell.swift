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

    @IBOutlet weak var weatherTypeLbl:UILabel!
    @IBOutlet weak var cityLbl:UILabel!
    @IBOutlet weak var temperatureLbl:UILabel!
    @IBOutlet weak var humidityLbl:UILabel!
    @IBOutlet weak var windLbl:UILabel!
    @IBOutlet weak var dewPointLbl:UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    
    private var currentWeatherItemsDict: [String:String]?
    
    let currentWeatherItem = WeatherTableViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(currentWeatherItem.temperature)
        self.currentWeatherItemsDict = UserDefaults.standard.dictionary(forKey: "currentWeather") as? [String:String]
        
        if self.currentWeatherItemsDict != nil {
            for (key, value) in self.currentWeatherItemsDict! {
                switch key {
                case "Condition" : weatherTypeLbl?.text = value
                case "Temperature" : temperatureLbl?.text = value //self.temperature = value
                case "Tendency" : pressureLbl?.text = value
                case "Humidity" : humidityLbl?.text = value
                //case "Humidex" :  = value
                case "Dewpoint" : dewPointLbl?.text = value
                case "Wind" : windLbl?.text = value
                //case "Index" : self.airQuality = value
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
