//
//  DemoCell.swift
//  Meteros
//
//  Created by Sanjeev on 25/02/19.
//  Copyright © 2019 Sanjeev. All rights reserved.
//

import FoldingCell
import UIKit
import RealmSwift
import GoogleMaps
import CoreLocation

class DemoCell: FoldingCell {
    let uiRealm = try! Realm()
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet weak var mapBackgroundView: GMSMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var recclassLabel: UILabel!
    @IBOutlet weak var fallLabel: UILabel!
    
    
    var number: Int = 0 {
        didSet {
            
            mapBackgroundView.clear()
            
            
            var objs = self.uiRealm.objects(RealmRootClass.self)
            objs = objs.sorted(byKeyPath: "mass", ascending: true)
            
            
            closeNumberLabel.text = String(objs[number].id)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"//this your string date format
            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            var convertedDate : Date!
            convertedDate = (dateFormatter.date(from: objs[number].year) ?? nil)!
            dateFormatter.dateFormat = "yyyy"
            let yearDate = (dateFormatter.string(from: convertedDate))
            dateLabel.text = yearDate
            
            nameLabel.text = String(objs[number].name)
            massLabel.text = String(format: "%g", (objs[number].mass))
            recclassLabel.text = String(objs[number].recclass)
            fallLabel.text = String(objs[number].fall)
            
            do {
                if let styleURL = Bundle.main.url(forResource: "custom", withExtension: "json") {
                    mapBackgroundView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
            let lat = Double(objs[number].reclat)
            let lon = Double(objs[number].reclong)
            let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0 , longitude: lon ?? 0  , zoom: 5.0)
            mapBackgroundView.isMyLocationEnabled = true
            mapBackgroundView?.animate(to: camera)
            
            let meteorMarker = GMSMarker()
            meteorMarker.position = CLLocationCoordinate2D(latitude:lat ?? 0, longitude: lon ?? 0)
            meteorMarker.title = String(objs[number].name)
            meteorMarker.icon = UIImage(named: "mapMarker")
            meteorMarker.map = self.mapBackgroundView
            
        }
    }

    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }

    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension DemoCell {

    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
