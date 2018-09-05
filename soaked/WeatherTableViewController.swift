//
//  WeatherTableViewController.swift
//  soaked
//
//  Created by Colby Timm on 2018-08-26.
//  Copyright © 2018 Colby Timm. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    private var weatherItems: [WeatherItem]?
    private var currentWeatherItemsDict: [String:String]?
    private let termList = ["Condition","Temperature","Tendency","Humidity","Humidex","Dewpoint","Wind","Index"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        if let tableView = self.view as? UITableView {
            tableView.backgroundView = UIImageView(image: UIImage(named: "mtns_background"))
            tableView.contentMode = .scaleAspectFit
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func fetchData() {
        let feedParser = WeatherParser()
        feedParser.parseWeather(url: "https://weather.gc.ca/rss/city/bc-74_e.xml") { (weatherItems) in
            self.weatherItems = weatherItems

            let query = self.weatherItems![1].summary
            self.weatherItems?.remove(at: 1)
            
            self.currentWeatherItemsDict = self.getValue(query: query, terms: self.termList)
            UserDefaults.standard.set(self.currentWeatherItemsDict, forKey: "currentWeather")
            
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
            return 100.0
        }
        return 130
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyleUITableViewCell.CellStyle.Default, reuseIdentifier: "MainCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainWeatherTableViewCell
            return cell
        }
            
        else if indexPath.row == 1 {
            //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyleUITableViewCell.CellStyle.Default, reuseIdentifier: "MainCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentWeatherTableViewCell
            return cell
        }

        else {
            let item = weatherItems?[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
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


