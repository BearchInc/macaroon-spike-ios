import Foundation
import Alamofire
import BRYHTMLParser

class Github {
    
    var mgr: Alamofire.Manager!
    let loginUrl = "https://github.com/login"
    let sessionUrl = "https://github.com/session"
    let home = "https://github.com"
    let domain = ".github.com"
    
    func getSessionCookies(callback: [NSHTTPCookie] -> Void) {
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        let cooks = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        // makes no difference whether it's set or left at default
        cfg.HTTPCookieStorage = cooks
        cfg.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        mgr = Alamofire.Manager(configuration: cfg)
        
        self.login(callback)
    }
    
    func login(callback: [NSHTTPCookie] -> Void) {
        mgr.request(.GET, self.loginUrl, headers:["User-Agent":""]).response { (req, res, data, error) -> Void in
            let parser = try? HTMLParser(data: data)
            var token = ""
            let body = parser?.body
            let inputNodes = body?.findChildTags("input")
            for node in inputNodes! {
                if node.getAttributeNamed("name") == "authenticity_token" {
                    token = node.getAttributeNamed("value")
                    print("Token: \(token)")
                    print("\n")
                }
            }
            self.session(token, callback: callback)
        }
    }
    
    func session(token: String, callback: [NSHTTPCookie] -> Void) {
        let sessionUrl = "https://github.com/session"
        let payload = ["authenticity_token":token, "utf8":"✓","login":"joaobearch", "password":"Unseen2015"]
        Alamofire.request(.POST, sessionUrl, parameters: payload).response {
            (req, res, data, error) -> Void in
            let c = NSHTTPCookie.cookiesWithResponseHeaderFields(res?.allHeaderFields as! [String : String], forURL: NSURL(string:"")!)
            callback(c)
        }
    }
    
}