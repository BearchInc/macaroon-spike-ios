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
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        // makes no difference whether it's set or left at default
        configuration.HTTPCookieStorage = cookieJar
        configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        mgr = Alamofire.Manager(configuration: configuration)
        
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
                }
            }
            self.session(token, callback: callback)
        }
    }
    
    func session(token: String, callback: [NSHTTPCookie] -> Void) {
        let sessionUrl = "https://github.com/session"
        let payload = ["authenticity_token":token, "utf8":"✓","login":"joaobearch", "password":"Unseen2015"]
        mgr.request(.POST, sessionUrl, parameters: payload).response {
            (req, res, data, error) -> Void in
//            let cookieArray = NSHTTPCookie.cookiesWithResponseHeaderFields(res?.allHeaderFields as! [String : String], forURL: NSURL(string:"")!)
//            callback(cookieArray)
        }
    }
}

class Twitter {
    var mgr: Alamofire.Manager!
    let loginUrl = "https://twitter.com/login"
    let sessionUrl = "https://twitter.com/sessions"
    let home = "https://twitter.com"
    let domain = ".twitter.com"
    var cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    func getSessionCookies(callback: [NSHTTPCookie] -> Void) {
        
        // makes no difference whether it's set or left at default
        configuration.HTTPCookieStorage = cookieJar
        configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        mgr = Alamofire.Manager(configuration: configuration)
        
        self.login(callback)
    }
    
    func login(callback: [NSHTTPCookie] -> Void) {
        mgr.request(.GET, self.loginUrl, headers:["User-Agent":"curl/7.43.0"]).response { (req, res, data, error) -> Void in
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
                break;
            }
            self.session(token, callback: callback)
        }
    }
    
    func session(token: String, callback: [NSHTTPCookie] -> Void) {
        let payload = ["authenticity_token":token, "session[username_or_email]":"not_lisardo", "session[password]":"**"]
        print(sessionUrl)
        mgr.request(.POST, self.sessionUrl, headers:["User-Agent":"curl/7.43.0"], parameters: payload).response { (req, res, data, error) -> Void in
            let cookieArray = NSHTTPCookie.cookiesWithResponseHeaderFields(res?.allHeaderFields as! [String : String], forURL: NSURL(string:"")!)
            callback(cookieArray)
        }
    }
    
}