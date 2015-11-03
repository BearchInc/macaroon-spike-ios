import Foundation
import Alamofire
import BRYHTMLParser

class Twitter {
    var manager: Alamofire.Manager = NetworkManager().manager!
    let loginUrl = "https://twitter.com/login"
    let sessionUrl = "https://twitter.com/sessions"
    let home = "https://twitter.com"
    let domain = ".twitter.com"
    
    func getSessionCookies(callback: [NSHTTPCookie] -> Void) {
        self.login(callback)
    }
    
    func login(callback: [NSHTTPCookie] -> Void) {
        manager.request(.GET, self.loginUrl, headers:["User-Agent":"curl/7.43.0"]).response { (req, res, data, error) -> Void in
            let parser = try? HTMLParser(data: data)
            var token = ""
            let body = parser?.body
            let inputNodes = body?.findChildTags("input")
            for node in inputNodes! {
                if node.getAttributeNamed("name") == "authenticity_token" {
                    token = node.getAttributeNamed("value")
                    print("Token: \(token)")
                    break;
                } else {
                    continue;
                }
            }
            self.session(token, callback: callback)
        }
    }
    
    func session(token: String, callback: [NSHTTPCookie] -> Void) {
        let payload = ["authenticity_token":token, "session[username_or_email]":"not_lisardo", "session[password]":"1lisa3do"]
        print(sessionUrl)
        manager.request(.POST, self.sessionUrl, headers:["User-Agent":"curl/7.43.0"], parameters: payload).response { (req, res, data, error) -> Void in
            let cookieArray = self.manager.session.configuration.HTTPCookieStorage!.cookies!
            callback(cookieArray)
            self.manager.session.invalidateAndCancel()
        }
    }
}