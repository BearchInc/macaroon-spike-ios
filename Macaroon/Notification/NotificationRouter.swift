import UIKit
import Alamofire
import ObjectMapper

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
        
		let notification = Mapper<Notification>().map(userInfo)!
		var url = ""
		switch identifier {
		case NotificationSettings.ACCEPT_ACTION_ID:
			print("Authorize was selected")
            url = notification.loginUrl!
		default:
			print("Where da fuck did you click???")
		}
        
//        req = Alamofire.request(.GET, "https://github.com/login")
        
		notification.loginFields["login"] = "joaoabearch"
        notification.loginFields["password"] = "Unseen2015"
        request = Alamofire.request(.POST, url, parameters: notification.loginFields, headers: ["Cookie": notification.headers])
			.responseJSON { response in
				print("omg")
				debugPrint(response)
				completionHandler()
		}
		debugPrint(request)
	}
}
