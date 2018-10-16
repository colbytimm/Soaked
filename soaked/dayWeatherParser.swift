//
//  dayWeatherParser.swift
//  soaked
//
//  Created by Colby Timm on 2018-10-10.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import Foundation

struct HourlyForecastItem {
    var date: String
    var condition: String
    var temperature: String
    var LOP: String //Likelihood of Precipitation
    var windSpeed: String
}

struct SunItem {
    var sunset: String
    var sunrise: String
}

// Download XML from Environment Canada

class DayWeatherParser: NSObject, XMLParserDelegate {
    var hourlyForecastItems: [HourlyForecastItem] = []
    var sunItems: [SunItem] = []
    
    private var currentElement = ""
    
    private var currentDate: String = "" {
        didSet {
            currentDate = currentDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCondition: String = "" {
        didSet {
            currentCondition = currentCondition.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTemp: String = "" {
        didSet {
            currentTemp = currentTemp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLOP: String = "" {
        didSet {
            currentLOP = currentLOP.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentWindSpeed: String = "" {
        didSet {
            currentWindSpeed = currentWindSpeed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentSunrise: String = "" {
        didSet {
            currentSunrise = currentSunrise.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentSunset: String = "" {
        didSet {
            currentSunset = currentSunset.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parseCompletionHandler: (([HourlyForecastItem]) -> Void)?
    
    func parseWeather(url: String, completionHandler: (([HourlyForecastItem]) -> Void)?) {
        self.parseCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            // Parse XML data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "entry" {
            currentDate = ""
            currentCondition = ""
            currentTemp = ""
            currentLOP = ""
            currentWindSpeed = ""
            currentSunrise = ""
            currentSunset = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        //case "title": currentTitle += string; getWeatherConditions(currentTitle: currentTitle)
        case "hourlyForecast": currentDate += string
        case "condition": currentCondition += string
        case "temperature": currentTemp += string
        case "lop": currentLOP += string
        case "speed": currentWindSpeed += string
        case "sunrise": currentSunrise += string
        case "sunset": currentSunset += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let hourlyForecastItem = HourlyForecastItem(date: currentDate, condition: currentCondition, temperature: currentTemp, LOP: currentLOP, windSpeed: currentWindSpeed)
            self.hourlyForecastItems.append(hourlyForecastItem)
            let sunItem = SunItem(sunset: currentSunset, sunrise: currentSunrise)
            self.sunItems.append(sunItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parseCompletionHandler?(hourlyForecastItems)
        //parseCompletionHandler?(sunItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
