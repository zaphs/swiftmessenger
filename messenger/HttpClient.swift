//
//  HttpClient.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

//import CoreLocation
import Alamofire
import SwiftyJSON
import MagicalRecord

enum HttpResponse{
    case Success(JSON)
    case Error(NSError)
}

class HttpClient {

    static let baseUrl = "http://ow16/api/wxapi/"
    static let sharedInstance = HttpClient()
    private(set) var inProgress = false
    
    static let usersOnlineUrl = HttpClient.baseUrl+"users/online"
    static let conversationsUrl = HttpClient.baseUrl+"conversations/latest"
    static let pingUrl = HttpClient.baseUrl+"ping"
    static let accountInfoUrl = HttpClient.baseUrl+"account"
        
    private init() {
        
    }
        
    func sendRequest(url:String, parameters: Dictionary<String, AnyObject>, callback: (HttpResponse) -> (Void)) {

        let authToken = NSUserDefaults.standardUserDefaults().stringForKey("auth_token") ?? ""

        print("HttpClient.sendRequest: \(url) with \(parameters)")

        self.inProgress = true
        Alamofire.request(.POST, url.URLString, parameters: parameters, encoding: .URL, headers: ["API_AUTH_TOKEN": authToken]).responseJSON(options: NSJSONReadingOptions(), completionHandler: { (response) -> Void in
            
            switch(response.result){
            case .Success(let data):
                    callback(HttpResponse.Success(JSON(data)))
            case .Failure( _):
                callback(HttpResponse.Error(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            self.inProgress = false
        })
    }
}

enum WXNotifications: String {
    case NewMessageReceived = "NewMessageReceived"
}