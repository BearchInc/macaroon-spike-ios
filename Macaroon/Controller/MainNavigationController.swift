import Foundation
import UIKit
import Alamofire

class MainNavigationController: UINavigationController {

	var notificationData: [NSObject: AnyObject]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePermissionRequest:", name: "PERMISSION_REQUEST_NOTIFICATION", object: nil)
        Twitter().getSessionCookies { (cookieArray:[NSHTTPCookie]) -> Void in
            var dict = [String:String]()
            for cookie in cookieArray {
                dict[cookie.name] = cookie.value
            }
            
            print(dict)

            Alamofire.request(.POST, "http://192.168.0.20:8080/permission/approve/twitter", parameters: ["cookies": dict], encoding: .JSON).response(completionHandler: { (req, res, data, error) -> Void in
                print(res?.statusCode)
            })
        }
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
