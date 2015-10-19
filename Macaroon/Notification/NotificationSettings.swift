import UIKit

class NotificationSettings: NSObject, GGLInstanceIDDelegate {

	static var instance = NotificationSettings()
	
	let firstActionId = "ACTION1"
	let secondActionId = "ACTION2"
	let categoryId = "CATEGORY"
	
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
		firstAction.title = "Authorize"
		firstAction.identifier = firstActionId
		firstAction.destructive = false
		firstAction.authenticationRequired = true
		
		let secondAction = UIMutableUserNotificationAction()
		secondAction.activationMode = .Background
		secondAction.title = "Decline"
		secondAction.identifier = secondActionId
		secondAction.destructive = false
		secondAction.authenticationRequired = true
		
		let actionCategory = UIMutableUserNotificationCategory()
		actionCategory.identifier = categoryId
		actionCategory.setActions([firstAction, secondAction], forContext: .Default)
		
		let categories = Set(arrayLiteral: actionCategory)
		let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
		
		return UIUserNotificationSettings(forTypes: types, categories: categories)
	}

}
