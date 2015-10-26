import Foundation

class Notification {
	
	var approveUrl: String!
	var rejectUrl: String!
	
	init(dictionary: [NSObject : AnyObject]) {
		approveUrl = dictionary["approve_url"] as? String
		rejectUrl = dictionary["reject_url"] as? String
	}
}
