//
//  MeteorDataClass.swift
//  Meteros
//
//  Created by Sanjeev on 25/02/19.
//  Copyright © 2019 Sanjeev. All rights reserved.
//

import Foundation 
import ObjectMapper


class MeteorDataClass : NSObject, NSCoding, Mappable{

	var fall : String?
	var geolocation : MeteorGeolocation?
	var id : String?
	var mass : String?
	var name : String?
	var nametype : String?
	var recclass : String?
	var reclat : String?
	var reclong : String?
	var year : String?


	class func newInstance(map: Map) -> Mappable?{
		return MeteorDataClass()
	}
	required init?(map: Map){}
	private override init(){}
   
    required convenience init?(_ map: Map) {
        self.init()
    }

	func mapping(map: Map)
	{
		fall <- map["fall"]
		geolocation <- map["geolocation"]
		id <- map["id"]
		mass <- map["mass"]
		name <- map["name"]
		nametype <- map["nametype"]
		recclass <- map["recclass"]
		reclat <- map["reclat"]
		reclong <- map["reclong"]
		year <- map["year"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        
         fall = aDecoder.decodeObject(forKey: "fall") as? String
         geolocation = aDecoder.decodeObject(forKey: "geolocation") as? MeteorGeolocation
         id = aDecoder.decodeObject(forKey: "id") as? String
         mass = aDecoder.decodeObject(forKey: "mass") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         nametype = aDecoder.decodeObject(forKey: "nametype") as? String
         recclass = aDecoder.decodeObject(forKey: "recclass") as? String
         reclat = aDecoder.decodeObject(forKey: "reclat") as? String
         reclong = aDecoder.decodeObject(forKey: "reclong") as? String
         year = aDecoder.decodeObject(forKey: "year") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		
		if fall != nil{
			aCoder.encode(fall, forKey: "fall")
		}
		if geolocation != nil{
			aCoder.encode(geolocation, forKey: "geolocation")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if mass != nil{
			aCoder.encode(mass, forKey: "mass")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if nametype != nil{
			aCoder.encode(nametype, forKey: "nametype")
		}
		if recclass != nil{
			aCoder.encode(recclass, forKey: "recclass")
		}
		if reclat != nil{
			aCoder.encode(reclat, forKey: "reclat")
		}
		if reclong != nil{
			aCoder.encode(reclong, forKey: "reclong")
		}
		if year != nil{
			aCoder.encode(year, forKey: "year")
		}

	}

}
