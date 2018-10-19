//
//  WeatherTableViewController.swift
//  soaked
//
//  Created by Colby Timm on 2018-08-26.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import UIKit

struct FutureWeatherItem {
    var condition: String
    var highTemp: String
    var lowTemp: String
}

class WeatherTableViewController: UITableViewController {
    private var weatherItems: [WeatherItem]?
    private var hourlyForecastItems: [HourlyForecastItem]?
    
    private var weatherURL = "https://weather.gc.ca/rss/city/bc-74_e.xml"
    
    private var currentWeatherItemsDict: [String:String]?
    private var conditionList: [String] = []
    private var highList: [String] = []
    private var lowList: [String] = []
    private let termList = ["Condition","Temperature","Tendency","Humidity","Humidex","Dewpoint","Wind","Index"]
    private let futureTermList = ["Low","High","Condition"]
    private let dayTermList = ["hourlyForecast","condition","temperature","lop","speed"]
    private let sunTermList = ["sunrise","sunset"]
    private let refreshCont = UIRefreshControl()
    
    var weatherParse: WeatherParser?
    var forecastParse: DayWeatherParser?
    var mainWeather: MainWeatherTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        fetchWeatherData()
        
        //fetchDataForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func setupView() {
        setupTableView()
        setupMessageLabel()
        setupActivityIndicatorView()
    }
    
    private func fetchWeatherData() {
        fetchData()
        self.refreshCont.endRefreshing()
        mainWeather?.activityIndicatorView.stopAnimating()
    }
    
    private func setupTableView() {
        //tableView.isHidden = true
        
        // Add Refresh Control to Table View
        tableView.refreshControl = refreshCont
        
        // Configure Refresh Control
        refreshCont.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    private func setupMessageLabel() {
        mainWeather?.messageLbl.isHidden = true
        mainWeather?.messageLbl.text = "Nothing show you."
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchWeatherData()
    }
    
    private func setupActivityIndicatorView() {
        mainWeather?.activityIndicatorView.startAnimating()
    }
    
    private func updateView() {
        let hasWeather = weatherParse?.weatherItems.count ?? 0 > 0
        tableView.isHidden = !hasWeather
        mainWeather?.messageLbl.isHidden = hasWeather
        
        if hasWeather {
            tableView.reloadData()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    
//    private func fetchDataForecast() {
//        let feedDayParser = DayWeatherParser()
//        feedDayParser.parseWeather(url: "http://dd.weather.gc.ca/citypage_weather/xml/BC/s0000141_e.xml") { (hourlyForecastItems) in
//            self.hourlyForecastItems = hourlyForecastItems
//
//            let query = self.hourlyForecastItems![1].date
//            //self.hourlyForecastItems?.remove(at: 1)
//
//            self.currentWeatherItemsDict = self.getDayValue(query: query, terms: self.termList)
//            UserDefaults.standard.set(self.currentWeatherItemsDict, forKey: "currentDayWeather")
//
//            OperationQueue.main.addOperation {
//                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
//            }
//        }
//    }
//
//    // Returns dictionary of current weather condition parameters
//    private func getDayValue(query: String, terms: [String]) -> [String:String] {
//        var resultsDict: [String: String] = [:]
//        for item in terms {
//            var pattern = item
//            pattern = item + ":(.*?)\n"
//            let regex = try! NSRegularExpression(pattern:pattern, options: [])
//
//            regex.enumerateMatches(in: query, options: [], range: NSMakeRange(0, query.utf16.count)) { result, flags, stop in
//                if let r = result?.range(at: 1), let range = Range(r, in: query) {
//                    resultsDict[item] = String(query[range])
//
//                }
//            }
//        }
//        return resultsDict
//    }
    
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    
    private func fetchData() {
        let feedParser = WeatherParser()
        feedParser.parseWeather(url: weatherURL) { (weatherItems) in
            self.weatherItems = weatherItems

            let query = self.weatherItems![1].summary
            self.weatherItems?.remove(at: 1)
            
            self.currentWeatherItemsDict = self.getValue(query: query, terms: self.termList)
            UserDefaults.standard.set(self.currentWeatherItemsDict, forKey: "currentWeather")
            
//            self.currentHourlyItemsDict = self.getValue(query: query, terms: self.termList)
//            UserDefaults.standard.set(self.currentHourlyItemsDict, forKey: "currentWeather")
        
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    // Returns dictionary of current weather condition parameters
    private func getValue(query: String, terms: [String]) -> [String:String] {
        var resultsDict: [String: String] = [:]
        for item in terms {
            var pattern = item
            pattern = item + ":(.*?)\n"
            let regex = try! NSRegularExpression(pattern:pattern, options: [])
            
            regex.enumerateMatches(in: query, options: [], range: NSMakeRange(0, query.utf16.count)) { result, flags, stop in
                if let r = result?.range(at: 1), let range = Range(r, in: query) {
                    resultsDict[item] = String(query[range])
                }
            }
        }
        return resultsDict
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let weatherItems = weatherItems else {
            return 2
        }
        
        return weatherItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 400.0
        }
        else if indexPath.row == 1 {
            return 140.0
        }
        return 80
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainWeatherTableViewCell
            return cell
        }
            
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentWeatherTableViewCell
            return cell
        }

        else {
            let item = weatherItems?[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
            if indexPath.item % 2 == 0 {
                //214, 216, 219)
                cell.backgroundColor = UIColor(red: 215/255, green: 216/255, blue: 219/255, alpha: 0.4)
            } else {
                cell.backgroundColor = UIColor.white
            }
            cell.item = item
            return cell
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
