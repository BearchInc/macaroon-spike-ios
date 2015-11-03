import Foundation
import Alamofire
import BRYHTMLParser

class Github {
    
    var manager: Alamofire.Manager = NetworkManager().manager!
    let loginUrl = "https://github.com/login"
    let sessionUrl = "https://github.com/session"
    let home = "https://github.com"
    let domain = ".github.com"
    
    func getSessionCookies(callback: [NSHTTPCookie] -> Void) {
        self.login(callback)
    }
    
    func login(callback: [NSHTTPCookie] -> Void) {
        manager.request(.GET, self.loginUrl, headers:["User-Agent":""]).response { (req, res, data, error) -> Void in
            let parser = try? HTMLParser(data: data)
            var token = ""
            let body = parser?.body
            let inputNodes = body?.findChildTags("input")
            for node in inputNodes! {
                if node.getAttributeNamed("name") == "authenticity_token" {
                    token = node.getAttributeNamed("value")
                    print("Token: \(token)")
                }
            }
            self.session(token, callback: callback)
        }
    }
    
    func session(token: String, callback: [NSHTTPCookie] -> Void) {
        let sessionUrl = "https://github.com/session"
        let payload = ["authenticity_token":token, "utf8":"✓","login":"joaobearch", "password":"Unseen2015"]
        manager.request(.POST, sessionUrl, parameters: payload).response {
            (req, res, data, error) -> Void in
            callback(self.manager.session.configuration.HTTPCookieStorage!.cookies!)
            self.manager.session.invalidateAndCancel()
        }
    }
}