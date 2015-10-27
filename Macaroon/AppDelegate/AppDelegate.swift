import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
		return NotificationSettings.instance.setupNotification(application)
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		if error.code == 3010 {
			print("Push notifications are not supported in the iOS Simulator.")
		} else {
			print("Registration failed with error: \(error)")
		}
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		NotificationSettings.instance.didRegisterForRemoteNotifications(application, deviceToken: deviceToken)
	}

	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		NotificationRouter.handleNotification(application, userInfo: userInfo, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
		
		NotificationRouter.handleNotification(application, userInfo: userInfo, identifier: identifier!, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
		print(userInfo)
		NotificationRouter.handleNotification(application, userInfo: userInfo, identifier: identifier!, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		print("didReceiveLocalNotification")
	}

}

