//
//  Album.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import SwiftyJSON

class Album: NSObject {
    
    var albumname: String?
    var id: String?
    var pics: String?
    
    class func parseModel(jsonDict: NSDictionary) -> [Album] {
        
        let json = JSON(jsonDict)
        
        //遍历数组
        var array = [Album]()
        for (_, subJson) in json["albums"] {
            
            let model = Album()
            model.albumname = subJson["albumname"].string
            model.id = subJson["id"].string
            model.pics = subJson["pics"].string
            array.append(model)
        }
        
        return array
    }

}
