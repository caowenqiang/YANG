//
//  PhotoModel.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import SwiftyJSON

class PhotoModel: NSObject {
    
    var albumid: String?
    var height: String?
    var pic: String?
    
    var pic_origin: String?
    var picid: String?
    var title: String?
    
    var uid: String?
    var width: String?
    
    //JSON解析
    class func parserModel(dict: NSDictionary) -> [PhotoModel] {
        
        let json = JSON(dict)
        
        var array = [PhotoModel]()
        for (_,subjson) in json["photos"] {
            let model = PhotoModel()
            
            model.albumid = subjson["albumid"].string
            model.height = subjson["height"].string
            model.pic = subjson["pic"].string
            
            model.pic_origin = subjson["pic_origin"].string
            model.picid = subjson["picid"].string
            model.title = subjson["title"].string
            
            model.uid = subjson["uid"].string
            model.width = subjson["width"].string
            
            array.append(model)
        }
        
        return array
    }

}
