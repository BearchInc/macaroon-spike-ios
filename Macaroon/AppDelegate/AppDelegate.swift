import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		let gcmToken = NSUserDefaults.standardUserDefaults().objectForKey("gcm_token")
		guard gcmToken != nil else {
			let settings: UIUserNotificationSettings =
			UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)

			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
			return true
		}
		
		print("Hey benchod, i know you forgot to write it down so here goes my token again")
		print("\(gcmToken!)")
		
		return true
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print("Registration failed with error \(error)")
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		
		let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
		instanceIDConfig.delegate = self
		GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
		let registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken, kGGLInstanceIDAPNSServerTypeSandboxOption:true]

		let gglInstance = GGLInstanceID.sharedInstance()
		gglInstance.tokenWithAuthorizedEntity("752048825109", scope: kGGLInstanceIDScopeGCM, options: registrationOptions) { (token, error) -> Void in
			
			guard error == nil else {
				print("Registration failed with error \(error)")
				return
			}
			
			print("GCM Registration succeeded with token \(token)")
			NSUserDefaults.standardUserDefaults().setObject(token, forKey: "gcm_token")
		}
		
		print("Device token - \(deviceToken)")
	}
	
	func onTokenRefresh() {
		print("Token refresh")
	}

	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		print("didReceiveRemoteNotification with fetch")
		print("\(userInfo)")
		completionHandler(.NewData)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		print("didReceiveRemoteNotification")
		print("\(userInfo)")
	}
	
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		print("didReceiveLocalNotification")
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

