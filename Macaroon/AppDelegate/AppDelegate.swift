import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		Parse.setApplicationId("wWnWoHxacJQauLNHHRkRdK8SW9mthV1TMCZEAyNQ", clientKey: "F0EWD9A2l1csWGWL9G6piDo8YRMiToNfEvnm9tYg")
		PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//		Parse.setApplicationId("35KfBxZ9GEZO5OTBNcX2dIuuDGHAZiU0pZXigtk3", clientKey: "9WoqUKodebc3QhEklOhNmzwZDIHp8SvoVwaJyART")

		return NotificationSettings.instance.setupNotification(application)
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		
		if error.code == 3010 {
			print("Push notifications are not supported in the iOS Simulator.")
		} else {
			print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
		}
		
		print("Registration failed with error \(error)")
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		
		let installation = PFInstallation.currentInstallation()
		installation.setDeviceTokenFromData(deviceToken)
		installation.saveInBackground()
		
		NotificationSettings.instance.didRegisterForRemoteNotifications(application, deviceToken: deviceToken)
	}

	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		PFPush.handlePush(userInfo)
		if application.applicationState == UIApplicationState.Inactive {
			PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		}
		
		NotificationRouter.handleNotification(application, userInfo: userInfo, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
		
		NotificationRouter.handleNotification(application, userInfo: userInfo, identifier: identifier!, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
		print(userInfo)
		NotificationRouter.handleNotification(application, userInfo: userInfo, identifier: identifier!, completionHandler: completionHandler)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

		PFPush.handlePush(userInfo)
		if application.applicationState == UIApplicationState.Inactive {
			PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		}
		
		print("didReceiveRemoteNotification")
		print("\(userInfo)")
	}
	
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		print("didReceiveLocalNotification")
	}

}

