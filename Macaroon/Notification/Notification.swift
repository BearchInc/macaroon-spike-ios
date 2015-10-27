import Foundation
import ObjectMapper

class Notification : Mappable {
	
	var loginUrl: String!
	var rejectUrl: String!
    var headers: String!
    var loginFields: [String : String]!
	
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
		loginUrl <- map["login_url"]
		rejectUrl <- map["reject_url"]
        headers <- map["headers"]
//        loginFields <- (map["login_fields"], TransformDict())
	}
}

class TransformDict: TransformType {
    typealias Object = [String : String]
    typealias JSON = String
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        
        let data = (value as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Object
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        return nil
    }
    
}
