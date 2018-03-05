//
//  UserInfoObject.swift
//  weCarry
//
//  Created by zixin cheng on 2018-02-14.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class UserInfoObject: NSObject {
    let userId: String
    let email: String
    let nickName: String
    let phoneNumber: String
    let offerIds: [String]
    let requestIds: [String]
    
    init(userId:String, email:String, nickName:String, phoneNumber:String, offerIds:[String], requestIds:[String]) {
        self.userId = userId;
        self.email = email;
        self.nickName = nickName;
        self.phoneNumber = phoneNumber;
        self.offerIds = offerIds;
        self.requestIds = requestIds;
    }
}
