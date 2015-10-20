import UIKit

class NotificationSettings: NSObject, GGLInstanceIDDelegate {

	static var instance = NotificationSettings()
	
	static let ACCEPT_ACTION_ID = "LOGIN_REQUEST_ACCEPT"
	static let DECLINE_ACTION_ID = "LOGIN_REQUEST_DECLINE"
	static let CATEGORY_ID = "LOGIN_REQUEST"
	
	func setupNotification(application: UIApplication) -> Bool {
		
		let gcmToken = NSUserDefaults.standardUserDefaults().stringForKey("gcm_token")
		if gcmToken == nil {
			application.registerUserNotificationSettings(getSettings())
			application.registerForRemoteNotifications()
			return true
		}
		
		print("Hey benchod, i know you forgot to write it down so here goes my token again")
		print("\(gcmToken!)")
		
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
	
	private func getSettings() -> UIUserNotificationSettings {
		let firstAction = UIMutableUserNotificationAction()
		firstAction.activationMode = .Background
		firstAction.title = "Authorize"
		firstAction.identifier = NotificationSettings.ACCEPT_ACTION_ID
		firstAction.destructive = false
		firstAction.authenticationRequired = true
		
		let secondAction = UIMutableUserNotificationAction()
		secondAction.activationMode = UIUserNotificationActivationMode.Background
		secondAction.title = "Decline"
		secondAction.identifier = NotificationSettings.DECLINE_ACTION_ID
		secondAction.destructive = true
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
