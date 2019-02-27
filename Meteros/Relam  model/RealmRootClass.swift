

import Foundation
import RealmSwift


class RealmRootClass: Object {

    @objc dynamic var fall: String!
	@objc dynamic var id: String!
    @objc dynamic var mass: Double = 0.0
	@objc dynamic var name: String!
	@objc dynamic var nametype: String!
	@objc dynamic var recclass: String!
	@objc dynamic var reclat: String!
	@objc dynamic var reclong: String!
	@objc dynamic var year: String!


    override class func primaryKey() -> String? {
        return "id"
    }
	
	

}
