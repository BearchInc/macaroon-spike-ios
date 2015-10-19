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
	}
}


//curl -XPOST https://gcm-http.googleapis.com/gcm/send -H "Content-Type:application/json" -H "Authorization:key=AIzaSyD4jrcwQEsQrbHdhbkn22NWPH2tAByr-Jo" -d '{
//"to" : "n1pthLorFvA:APA91bGJJZFAMN_O_eZsTYJGmy0koaAUtO6cRlWDbFiCxzfGhH3E4-134GobUWEoYEAjfIZl2pjQ75j_Xq2IctttyjfpeM3FUfbjPapzslrbDAjfOTWndRfGbcmnqDNxBbhx1GSuhGeO",
//"content_available" : true,
//"notification" : {
//	"title": "@Diego Borges",
//	"body": "Hey bro, i need your permission to mess around with the database héhé!",
//	"click_action": "CATEGORY",
//}
//}'