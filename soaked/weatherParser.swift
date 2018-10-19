//
//  weatherParser.swift
//  soaked
//
//  Created by Colby Timm on 2018-08-25.
//  Copyright © 2018 Colby Timm. All rights reserved.
//
// Parse XML weather information from Environment Canada
//

import Foundation

struct WeatherItem {
    var title: String
    var date: String
    var summary: String
    var condition: String
    var highTemp: String
    var lowTemp: String
    var pop: String
}

// Download XML from Environment Canada

class WeatherParser: NSObject, XMLParserDelegate {
    var weatherItems: [WeatherItem] = []
    private var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDate: String = "" {
        didSet {
            currentDate = currentDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentSummary: String = "" {
        didSet {
            currentSummary = currentSummary.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            currentSummary = currentSummary.replacingOccurrences(of: "<b>", with: "")
            currentSummary = currentSummary.replacingOccurrences(of: "</b>", with: "")
            currentSummary = currentSummary.replacingOccurrences(of: "<br/>", with: "")
            currentSummary = currentSummary.replacingOccurrences(of: "&deg;C", with: "")
            if currentSummary.range(of:"Temperature") != nil {
                
            }
        }
    }
    private var currentCondition: String = "" {
        didSet {
            currentCondition = currentCondition.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentHighTemp: String = "" {
        didSet {
            currentHighTemp = currentHighTemp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLowTemp: String = "" {
        didSet {
            currentLowTemp = currentLowTemp.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPop: String = "" {
        didSet {
            currentPop = currentPop.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parseCompletionHandler: (([WeatherItem]) -> Void)?
    
    func parseWeather(url: String, completionHandler: (([WeatherItem]) -> Void)?) {
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
            currentTitle = ""
            currentDate = ""
            currentSummary = ""
            currentCondition = ""
            currentHighTemp = ""
            currentLowTemp = ""
            currentPop = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string; getWeatherConditions(currentTitle: currentTitle)
        case "published": currentDate += string
        case "summary": currentSummary += string;
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let weatherItem = WeatherItem(title: currentTitle, date: currentDate, summary: currentSummary, condition: currentCondition, highTemp: currentHighTemp, lowTemp: currentLowTemp, pop: currentPop)
            self.weatherItems.append(weatherItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parseCompletionHandler?(weatherItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func getWeatherConditions(currentTitle: String) {
        currentCondition = currentTitle.slice(from: ": ", to: ".") ?? "-"
        currentLowTemp = currentTitle.slice(from: "Low ", to: ".") ?? "-"
        currentHighTemp = currentTitle.slice(from: "High ", to: ".") ?? "-"
        currentPop = currentTitle.slice(from: "POP ", to: ".") ?? ""
    }
        
}
