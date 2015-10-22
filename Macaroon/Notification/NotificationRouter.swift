import UIKit
import Alamofire

class NotificationRouter {

    static var request: Request!
    
	static func handleNotification(application: UIApplication, userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		print("didReceiveRemoteNotification with fetch")
		print("\(userInfo)")
		
		print("App state = \(application.applicationState)")
		
		switch (application.applicationState) {
		case .Active:
			print("App received notification while active")
			NSNotificationCenter.defaultCenter().postNotificationName("PERMISSION_REQUEST_NOTIFICATION", object: userInfo)
			break
		case .Inactive:
			print("App received notification while inactive")
			NSNotificationCenter.defaultCenter().postNotificationName("PERMISSION_REQUEST_NOTIFICATION", object: userInfo)
			break
		case .Background:
			print("App received notification while in background - will be ignored")
			break
		}
		
		completionHandler(.NoData)
	}
	
	static func handleNotification(application: UIApplication, userInfo: [NSObject : AnyObject], identifier: String, completionHandler: () -> Void) {
		
		let notification = Notification(dictionary: userInfo)
		var url = ""
		switch identifier {
		case NotificationSettings.ACCEPT_ACTION_ID:
			print("Authorize was selected")
            url = notification.approveUrl
		case NotificationSettings.DECLINE_ACTION_ID:
			url = notification.rejectUrl
		default:
			print("Where da fuck did you click???")
		}
		
		request = Alamofire.request(.GET, url)
			.responseJSON { response in
				print("omg")
				debugPrint(response)
				completionHandler()
		}
		debugPrint(request)
		print(userInfo)
	}
}
