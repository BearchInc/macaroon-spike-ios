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
		
		switch identifier {
		case NotificationSettings.ACCEPT_ACTION_ID:
			print("Authorize was selected")
            
            
            let headers = [
                "Authorization": "key=AIzaSyD4jrcwQEsQrbHdhbkn22NWPH2tAByr-Jo",
                "Content-Type": "application/json"
            ]
            
            let parameters = [
                "to": "APA91bHdqqjRKNVEVk5bEBZdN4kUOeE5sP1U32Bdtz2zQD-fdtdTLLVRf6qY1-o-azONr7hDOZQZpuv-bDnOc9eZ7S-93TsnFWxvPhZmv5yLW7b27fcqL2BjLF23a8lxifZnk8wlidNu9UVomvADaKWcCtIj7MkHCw",
                "content_available": true,
                "notification": [
                    "title": "Login Accepted",
                    "body": "Login was accepted"
                ]
            ]
            
            request = Alamofire.request(.POST, "https://gcm-http.googleapis.com/gcm/send", headers: headers, parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    print("omg")
                    debugPrint(response)
                    completionHandler()
                }
            debugPrint(request)
            print("ygo")
            print(userInfo)
		case NotificationSettings.DECLINE_ACTION_ID:
			print("Decline was selected")
		default:
			print("Where da fuck did you click???")
		}
		
//		completionHandler()
	}
}
