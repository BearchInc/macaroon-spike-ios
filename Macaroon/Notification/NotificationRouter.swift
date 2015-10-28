import UIKit
import Alamofire
import ObjectMapper
import Parse

class NotificationRouter {

    static var request: Request!
    
	static func handleNotification(application: UIApplication, userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		PFPush.handlePush(userInfo)
		if application.applicationState == UIApplicationState.Inactive {
			PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		}
		
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
        
		let notification = Mapper<Notification>().map(userInfo["aps"])!
		var url = ""
		switch identifier {
		case NotificationSettings.ACCEPT_ACTION_ID:
			print("Authorize was selected")
            approve(notification, completionHandler: completionHandler)
            return
		case NotificationSettings.DECLINE_ACTION_ID:
			print("Reject was selected")
			url = notification.rejectUrl!
		default:
			print("Where da fuck did you click???")
		}
		
		request = Alamofire.request(.GET, url)
			.responseJSON { response in
				debugPrint(response)
				completionHandler()
		}
		debugPrint(request)
	}
    
    static func approve(notification: Notification, completionHandler: () -> Void) {
        Github().getSessionCookies({ cookies in
            let payload = ["cookies" : cookies]
            let request = Alamofire.request(.POST, notification.loginUrl, parameters: payload, encoding: .JSON)
                .response {
                    (req, res, data, error) -> Void in
                    print(NSString(data: req!.HTTPBody!, encoding: NSUTF8StringEncoding))
                    completionHandler()
                    res?.allHeaderFields
                    
            }
            print(request)
        })
    }
    
}
