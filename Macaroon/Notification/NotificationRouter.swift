import UIKit

class NotificationRouter {

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
		
		switch identifier {
		case NotificationSettings.ACCEPT_ACTION_ID:
			print("Authorize was selected")
		case NotificationSettings.DECLINE_ACTION_ID:
			print("Decline was selected")
		default:
			print("Where da fuck did you click???")
		}
		
		completionHandler()
	}
}
