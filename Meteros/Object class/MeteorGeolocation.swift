//
//  MeteorGeolocation.swift
//  Meteros
//
//  Created by Sanjeev on 25/02/19.
//  Copyright © 2019 Sanjeev. All rights reserved.
//

import Foundation 
import ObjectMapper


class MeteorGeolocation : NSObject, NSCoding, Mappable{

	var coordinates : [Float]?
	var type : String?


	class func newInstance(map: Map) -> Mappable?{
		return MeteorGeolocation()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		coordinates <- map["coordinates"]
		type <- map["type"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         coordinates = aDecoder.decodeObject(forKey: "coordinates") as? [Float]
         type = aDecoder.decodeObject(forKey: "type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if coordinates != nil{
			aCoder.encode(coordinates, forKey: "coordinates")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}
