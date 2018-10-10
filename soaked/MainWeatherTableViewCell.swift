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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.currentWeatherItemsDict = UserDefaults.standard.dictionary(forKey: "currentWeather") as? [String:String]
        
        if self.currentWeatherItemsDict != nil {
            for (key, value) in self.currentWeatherItemsDict! {
                switch key {
                case "Condition" : weatherTypeLbl?.text = value
                case "Temperature" : temperatureLbl?.text = value.trimmingCharacters(in: .whitespaces) + "°"
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
