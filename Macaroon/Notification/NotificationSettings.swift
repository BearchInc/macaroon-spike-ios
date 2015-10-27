import UIKit
import Parse

class NotificationSettings: NSObject {

	static var instance = NotificationSettings()
	
	static let ACCEPT_ACTION_ID = "LOGIN_REQUEST_ACCEPT"
	static let DECLINE_ACTION_ID = "LOGIN_REQUEST_DECLINE"
	static let CATEGORY_ID = "LOGIN_REQUEST"
	
	func setupNotification(application: UIApplication) -> Bool {
		Parse.setApplicationId("wWnWoHxacJQauLNHHRkRdK8SW9mthV1TMCZEAyNQ", clientKey: "F0EWD9A2l1csWGWL9G6piDo8YRMiToNfEvnm9tYg")
		
		let registered = NSUserDefaults.standardUserDefaults().boolForKey("registered")
		if registered {
			return true
		}
		
		application.registerUserNotificationSettings(getSettings())
		application.registerForRemoteNotifications()
		
		return true
	}
	
	func didRegisterForRemoteNotifications(application: UIApplication, deviceToken: NSData) {
		let installation = PFInstallation.currentInstallation()
		installation.setDeviceTokenFromData(deviceToken)
		installation.saveInBackground()
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: "registered")
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
