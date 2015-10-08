import Foundation
import UIKit

class MainNavigationController: UINavigationController {

	var notificationData: [NSObject: AnyObject]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePermissionRequest:", name: "PERMISSION_REQUEST_NOTIFICATION", object: nil)
	}
	
	func handlePermissionRequest(notification: NSNotification) {
		notificationData = notification.object as? [NSObject: AnyObject]
		performSegue(Segue.PermissionViewControllerSegue)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue == Segue.PermissionViewControllerSegue {
			let vc = segue.destinationViewController as! PermissionViewController
			let title = notificationData!["aps"]!["alert"]!!["title"]!! as! String
			let body = notificationData!["aps"]!["alert"]!!["body"]!! as! String
			
			vc.notificationTitle = title
			vc.notificationBody = body
		}
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}
