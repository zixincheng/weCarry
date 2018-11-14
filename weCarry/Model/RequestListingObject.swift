//
//  RequestListingObject.swift
//  weCarry
//
//  Created by zixin cheng on 2018-02-15.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class RequestListingObject: NSObject {
    let userInfo: [String: String]
    let serviceType: String
    let packageType: String
    let travelInfo: [String: String]
    let itemInfo: [String: String]
    var phoneNumber : String
    var weChat : String
    var comments : String
    
    init(userInfo:[String:String], serviceType:String, packageType:String, travelInfo:[String: String], itemInfo:[String:String], phoneNumber:String, weChat:String, comments:String) {
        self.userInfo = userInfo;
        self.serviceType = serviceType;
        self.packageType = packageType;
        self.travelInfo = travelInfo;
        self.itemInfo = itemInfo;
        self.phoneNumber = phoneNumber;
        self.weChat = weChat;
        self.comments = comments;
    }
    
}
