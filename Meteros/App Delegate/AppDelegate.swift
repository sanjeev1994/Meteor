//
//  AppDelegate.swift
//  Meteros
//
//  Created by Sanjeev on 25/02/19.
//  Copyright © 2019 Sanjeev. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let uiRealm = try! Realm()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyDcl06OjGBJ9KMroDXnTHiz8pcZbNqvmBE")
        GMSPlacesClient.provideAPIKey("AIzaSyDcl06OjGBJ9KMroDXnTHiz8pcZbNqvmBE")
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
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
                    case .failure(let error):
                        print(error)
                    }
            }
        }
        else
        {
            print("No network")
            
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

