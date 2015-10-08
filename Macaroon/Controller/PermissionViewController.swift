import Foundation
import UIKit

class PermissionViewController: UIViewController {
	
	var notificationTitle: String!
	var notificationBody: String!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = notificationTitle
		messageLabel.text = notificationBody
	}
}
