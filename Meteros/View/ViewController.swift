//
//  ViewController.swift
//  Meteros
//
//  Created by Sanjeev on 25/02/19.
//  Copyright © 2019 Sanjeev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift
import FoldingCell

class ViewController: UITableViewController {

    let uiRealm = try! Realm()
    
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let objs = self.uiRealm.objects(RealmRootClass.self)
        if objs.count == 0
        {
            updateApi()
        }
        else
        {
           
            self.setup()
            
        }
       
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func updateApi() {
        if Reachability.isConnectedToNetwork(){
            let url = "https://data.nasa.gov/resource/y77d-th95.json"
            let realmFilePath = Realm.Configuration.defaultConfiguration.fileURL
            print("Realm File Path",realmFilePath!)
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default)
                .responseArray{ (response: DataResponse<[MeteorDataClass]>) in
                    switch response.result {
                    case .success:
                    
                    
                        let responseList = response.result.value
                        for dataList in responseList!
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"//this your string date format
                            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                            var convertedDate : Date!
                            if dataList.year != nil
                            {
                                convertedDate = (dateFormatter.date(from: dataList.year!) ?? nil)!
                            
                            
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let checkDate : Date = (formatter.date(from: "2010-12-31 23:59:59"))!
                            
                                if convertedDate > checkDate
                                {
                                    let mapObjects = RealmRootClass()
                                    mapObjects.fall = dataList.fall
                                    mapObjects.id = dataList.id
                                    let massStr : String = dataList.mass!
                                    mapObjects.mass = Double(massStr)!
                                    mapObjects.name = dataList.name
                                    mapObjects.nametype = dataList.nametype
                                    mapObjects.recclass = dataList.recclass
                                    mapObjects.reclat = dataList.reclat
                                    mapObjects.reclong = dataList.reclong
                                    mapObjects.year = dataList.year
                                
                                    try! self.uiRealm.write {
                                        self.uiRealm.add(mapObjects, update: true)
                                    }
                                
                                }
                            
                            
                            }
                        
                        
                        }
                    
                        self.setup()
                    case .failure(let error):
                        print(error)
                    }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please Connect to internet to load the data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup() {
        
            self.cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
            self.tableView.estimatedRowHeight = Const.closeCellHeight
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl = UIRefreshControl()
                self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshHandler), for: .valueChanged)
            }
        
        
    }
    
   
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension ViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        let objs = self.uiRealm.objects(RealmRootClass.self)
        return objs.count
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}

