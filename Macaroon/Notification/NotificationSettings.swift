import UIKit

class NotificationSettings: NSObject, GGLInstanceIDDelegate {

	static var instance = NotificationSettings()
	
	func setupNotification(application: UIApplication) -> Bool {
		
		let gcmToken = NSUserDefaults.standardUserDefaults().stringForKey("gcm_token")
		guard gcmToken != nil else {
			let settings: UIUserNotificationSettings =
			UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
			
			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
			return true
		}
		
		let settings = getSettings(gcmToken!)
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		return true
	}
	
	func didRegisterForRemoteNotifications(application: UIApplication, deviceToken: NSData) {
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
		
	}
	
	private func getSettings(gcmToken: String) -> UIUserNotificationSettings {
		print("Hey benchod, i know you forgot to write it down so here goes my token again")
		print("\(gcmToken)")
		
		let firstAction = UIMutableUserNotificationAction()
		firstAction.activationMode = .Background
		firstAction.title = "Action 1"
		firstAction.identifier = ""
		firstAction.destructive = false
		firstAction.authenticationRequired = true
		
		let actionCategory = UIMutableUserNotificationCategory()
		actionCategory.identifier = ""
		actionCategory.setActions([firstAction], forContext: .Default)
		
		let categories = Set(arrayLiteral: actionCategory)
		let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
		
		return UIUserNotificationSettings(forTypes: types, categories: categories)
	}

}
