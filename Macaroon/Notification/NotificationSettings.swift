import UIKit

class NotificationSettings: NSObject, GGLInstanceIDDelegate {

	static var instance = NotificationSettings()
	
	static let FIRST_ACTION_ID = "ACTION1"
	static let SECOND_ACTION_ID = "ACTION2"
	static let CATEGORY_ID = "CATEGORY"
	
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
		firstAction.identifier = NotificationSettings.FIRST_ACTION_ID
		firstAction.destructive = false
		firstAction.authenticationRequired = true
		
		let secondAction = UIMutableUserNotificationAction()
		secondAction.activationMode = .Background
		secondAction.title = "Decline"
		secondAction.identifier = NotificationSettings.SECOND_ACTION_ID
		secondAction.destructive = false
		secondAction.authenticationRequired = false
		
		let actionCategory = UIMutableUserNotificationCategory()
		actionCategory.identifier = NotificationSettings.CATEGORY_ID
		actionCategory.setActions([firstAction, secondAction], forContext: .Default)
		
		let categories = Set(arrayLiteral: actionCategory)
		let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
		
		return UIUserNotificationSettings(forTypes: types, categories: categories)
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
