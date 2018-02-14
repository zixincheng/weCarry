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
    
    let pickuplocation: GeoPoint
    let leftWeight: String
    let userId: String
    let avalibleService: [String: Bool]
    let avaliblePackage: [String: Bool]
    let travelInfo: [String: String]
    
    init(userId:String, leftWeight:String, pickuplocation:GeoPoint, avalibleService:[String: Bool], avaliblePackage:[String: Bool], travelInfo:[String: String]) {
        self.pickuplocation = pickuplocation;
        self.leftWeight = leftWeight;
        self.userId = userId;
        self.avalibleService = avalibleService;
        self.avaliblePackage = avaliblePackage;
        self.travelInfo = travelInfo;
    }

}
