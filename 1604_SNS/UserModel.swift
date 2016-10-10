//
//  UserModel.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import SwiftyJSON

class UserModel: NSObject {
    
    var credit: String?
    var experience: String?
    var friendnum: String?
    
    var groupid: String?
    var headimage: String?
    var lastactivity: String?
    
    var realname: String?
    var uid: String?
    var username: String?
    
    var viewnum: String?
    
    class func parseModel(data: NSData) -> [UserModel] {
        
        var array = [UserModel]()
        
        let json = JSON(data: data)
        
        //遍历数组
        for (_, subjson) in json["users"] {
            
            let model = UserModel()
            model.credit = subjson["credit"].string
            model.experience = subjson["experience"].string
            model.friendnum = subjson["friendnum"].string

            model.groupid = subjson["groupid"].string
            model.headimage = subjson["headimage"].string
            model.lastactivity = subjson["lastactivity"].string
            
            model.realname = subjson["realname"].string
            model.uid = subjson["uid"].string
            model.username = subjson["username"].string
            
            model.viewnum = subjson["viewnum"].string
            
            array.append(model)
        }
        
        return array
        
    }
    
    
}
