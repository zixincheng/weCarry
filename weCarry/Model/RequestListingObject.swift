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
    let pickuplocation: GeoPoint
    let userInfo: [String: String]
    let serviceType: String
    let packageType: String
    let travelInfo: [String: String]
    let itemInfo: [String: String]
    
    init(userInfo:[String:String], pickuplocation:GeoPoint, serviceType:String, packageType:String, travelInfo:[String: String], itemInfo:[String:String]) {
        self.pickuplocation = pickuplocation;
        self.userInfo = userInfo;
        self.serviceType = serviceType;
        self.packageType = packageType;
        self.travelInfo = travelInfo;
        self.itemInfo = itemInfo;
    }
    
}
