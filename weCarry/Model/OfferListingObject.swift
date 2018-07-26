//
//  OfferListingObject.swift
//  weCarry
//
//  Created by zixin cheng on 2/7/18.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class OfferListingObject: NSObject {
    
    var leftWeight: String
    let userInfo: [String: String]
    let avalibleService: [String: Bool]
    let avaliblePackage: [String: Bool]
    let travelInfo: [String: String]
    var phoneNumber : String
    var weChat : String
    var comments : String
    

    
    init(userInfo:[String: String], leftWeight:String, avalibleService:[String: Bool], avaliblePackage:[String: Bool], travelInfo:[String: String], phoneNumber:String, weChat:String, comments:String) {
        self.leftWeight = leftWeight;
        self.userInfo = userInfo;
        self.avalibleService = avalibleService;
        self.avaliblePackage = avaliblePackage;
        self.travelInfo = travelInfo;
        self.phoneNumber = phoneNumber;
        self.weChat = weChat;
        self.comments = comments;
    }
    
    

}
