//
//  HTTPHelper.swift
//  Mihtra
//
//  Created by Gyan on 16/01/17.
//  Copyright © 2017 Gyana. All rights reserved.
//

import UIKit
import Alamofire

class HTTPHelper: NSObject {
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    private func listenForReachability(WhenReachable : @escaping () -> (), WhenNotReachable : @escaping () -> ()) {
        if (self.reachabilityManager?.isReachable)! {
            WhenReachable()
        } else {
            WhenNotReachable()
        }
    }
    
    /**
     This function return NSMutableURLRequest.
     */
    private func httpGeneratingUrlRequestFor(methodName: URLTYPE, params : NSDictionary!, SuccessWith: @escaping (_ req: URLRequest?)->(), noInterNetAlert: @escaping ()->()) {
        self.listenForReachability(WhenReachable: {
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                ]
            var request = URLRequest(url: ReturnUrlClass().returnUrlForMethod(methodName: methodName, param: params) as URL)
            request.allHTTPHeaderFields = headers
            SuccessWith(request)
        }) {
            noInterNetAlert()
        }
    }
    
    /**
     This function will give the api respnse through completion handler.
     */
    private func getResponceDataUsingAlamofire(methodName: URLTYPE, req : URLRequest, SuccessWith: @escaping (_ result: AnyObject?)->(), failureWith: @escaping (_ resultStr: AnyObject?)->()) {
        Alamofire.request(req as URLRequestConvertible)
            .responseJSON { response in
                print(methodName.hashValue)
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    switch response.result {
                    case .success:
                        if let JSON = response.result.value {
                            let json = JSON as? NSDictionary
                            print(json!)
                            SuccessWith(json)
                        }
                    case .failure(let error):
                        print(error)
                        failureWith(error as AnyObject?)
                    }
                } else {
                    switch response.result {
                    case .success:
                        if let JSON = response.result.value {
                            print(JSON)
                            let json = JSON as? NSDictionary
                            failureWith(json)
                        }
                    case .failure:
                        failureWith(response.error?.localizedDescription as AnyObject?)
                    }
                }
        }
    }
    
    
    func httpRequestForMethodName(viewcontroller : UIViewController, methodName: URLTYPE, HTTPMethod : HTTPMethod, headers : NSDictionary!, SuccessWith: @escaping (_ result: AnyObject?)->(), failureWith: @escaping (_ result: AnyObject?)->()) {
        self.httpGeneratingUrlRequestFor(methodName: methodName, params: headers, SuccessWith: { (req) in
            var request = req
            var body = ""
            for (index, item) in headers.allKeys.enumerated() {
                if index == 0 {
                    if let stringArray = headers.value(forKey: "\(item)") as? NSArray {
                        let grant_type = self.notPrettyString(from: stringArray)
                        let product : String = "&\(item)=" + grant_type!
                        body = body + product
                    } else {
                        let grant_type : String = "\(item)="+(headers.value(forKey: "\(item)") as? String)!
                        body = body + grant_type
                    }
                } else if let stringArray = headers.value(forKey: "\(item)") as? NSArray { 
                    let grant_type = self.notPrettyString(from: stringArray)
                    let product : String = "&\(item)=" + grant_type!
                    body = body + product
                } else {
                    let client_id : String = "&\(item)="+(headers.value(forKey: "\(item)") as? String)!
                    body = body + client_id
                }
            }
            request?.httpMethod = HTTPMethod.rawValue
            request?.httpBody = body.data(using: String.Encoding.utf8)!
            self.getResponceDataUsingAlamofire(methodName: methodName,req: request!, SuccessWith: { (result) in
                if result != nil {
                    let retVal : AnyObject = GPSeparateParam().sepearteParameterForMethod(methodName: methodName, parameters: result!)
                    SuccessWith(retVal)
                } else {
                    failureWith(result)
                }
            }, failureWith: { (resltStr) in
                failureWith(resltStr as AnyObject?)
            })
        }) {
            KVSpinnerView.dismiss()
            viewcontroller.showAllertWithMultipleActions(title: MessageTitle, message: "Please check your internet connection", actionTitles: ["OK"], actions: [{ (okaction) in }, nil])
        }
    }
    
    func httpForSaveHealthRecord(methodName: URLTYPE, HTTPMethod : HTTPMethod, headers : NSDictionary!, SuccessWith: @escaping (_ result: AnyObject?)->(), failureWith: @escaping (_ result: AnyObject?)->(), noInterNetAlert: @escaping ()->()) {
        self.httpGeneratingUrlRequestFor(methodName: methodName, params: headers, SuccessWith: { (req) in
            var request = req
            var body = ""
            let access_token : String = "&access_token="+(headers.value(forKey: "access_token") as? String)!
            body = body + access_token
            let record_type : String = "&mihtra_id="+(headers.value(forKey: "mihtra_id") as? String)!
            body = body + record_type
            let type_name : String = "&type_name="+(headers.value(forKey: "type_name") as? String)!
            body = body + type_name
            let type_id : String = "&type_id="+(headers.value(forKey: "type_id") as? String)!
            body = body + type_id
            let file_name : String = "&file_name="+(headers.value(forKey: "file_name") as? String)!
            body = body + file_name
            let file_extension : String = "&file_extension="+(headers.value(forKey: "file_extension") as? String)!
            body = body + file_extension
            let imageStr : String = (headers.value(forKey: "file") as? String)!
            let file : String = "&file="+(imageStr.replacingOccurrences(of: "+", with: "%2B"))
            body = body + file
            request?.httpMethod = HTTPMethod.rawValue
            request?.httpBody = body.data(using: String.Encoding.utf8)!
            self.getResponceDataUsingAlamofire(methodName: methodName, req: request!, SuccessWith: { (result) in
                if result != nil {
                    let retVal : AnyObject = GPSeparateParam().sepearteParameterForMethod(methodName: methodName, parameters: result as! [String:AnyObject]! as AnyObject)
                    SuccessWith(retVal)
                } else {
                    failureWith(result)
                }
            }, failureWith: { (resltStr) in
                failureWith(resltStr as AnyObject?)
            })
        }) {
            noInterNetAlert()
        }
    }
    
    fileprivate func notPrettyString(from object: Any) -> String? {
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func httpForGetRequestToGetAvailbletimeSlotes(methodName: URLTYPE, HTTPMethod : HTTPMethod, headers : NSDictionary!, SuccessWith: @escaping (_ result: AnyObject?)->(), failureWith: @escaping (_ result: AnyObject?)->(), noInterNetAlert: @escaping ()->()) {
        self.httpGeneratingUrlRequestFor(methodName: methodName, params: headers, SuccessWith: { (req) in
            var request = req
            request?.httpMethod = HTTPMethod.rawValue
            self.getResponceDataUsingAlamofire(methodName: methodName,req: request!, SuccessWith: { (result) in
                if result != nil {
                    let retVal : AnyObject = GPSeparateParam().sepearteParameterForMethod(methodName: methodName, parameters: result!)
                    SuccessWith(retVal)
                } else {
                    failureWith(result)
                }
            }, failureWith: { (resltStr) in
                failureWith(resltStr as AnyObject?)
            })
        }) {
            noInterNetAlert()
        }
    }
}
