//
//  ProfileModel.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    
    var username: String?
    var birthprovince: String?
    var birthcity: String?
    
    var resideprovince: String?
    var residecity: String?
    var email: String?
    
    var blood: String?
    var headimage: String?
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


