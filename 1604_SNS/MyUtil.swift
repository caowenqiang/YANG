//
//  MyUtil.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/**
 创建基本UI对象等的工具类
 */

class MyUtil: NSObject {
    
    //创建标签
    class func createLabel(frame: CGRect,text: String?) -> UILabel {
        
        let label = UILabel(frame: frame)
        label.text = text
        return label
    }
    
    //创建按钮
    class func createBtn(frame: CGRect,title: String?, target: AnyObject?, action: Selector) -> UIButton {
        let btn = UIButton(type: .System)
        btn.frame = frame
        //可选绑定
        if let btnTitle = title {
            btn.setTitle(btnTitle, forState: .Normal)
        }
        
        if let tmpTarget = target {
            btn.addTarget(tmpTarget, action: action, forControlEvents: .TouchUpInside)
        }
        
        return btn
    }
    
    //创建输入框
    /**
     *@param isPwd:是否是安全输入文字
     */
    class func createTextField(frame: CGRect,placeHolder: String?, isPwd: Bool) -> UITextField {
        
        let textField = UITextField(frame: frame)
        if let tmpPlaceHolder = placeHolder {
            textField.placeholder = tmpPlaceHolder
        }
        
        if isPwd {
            textField.secureTextEntry = true
        }
        
        textField.borderStyle = .RoundedRect
        
        return textField
    }
    
    
    //显示提示信息
    class func showAlert(
        onViewController vCtrl: UIViewController,
        msg: String,
        confirmClosure: (Void->Void)? ) {
        //UIAlertView和UIActionSheet
        //UIAlertController是他们的替换
        
        //UIAlertControllerStyle是用来区分Alert和ActionSheet的
        //UIAlertController: UIViewController
        //1.创建视图控制器
        let alertCtrl = UIAlertController(title: "温馨提示", message: msg, preferredStyle: .Alert)
        //let alertCtrl = UIAlertController(title: "温馨提示", message: msg, preferredStyle: .ActionSheet)
        
        //2.添加按钮
        let action = UIAlertAction(title: "确定", style: .Default) {
            (action) in
            //print("点击了按钮")
            if let myClosure = confirmClosure {
                myClosure()
            }
        }
        
        alertCtrl.addAction(action)
        //3.显示视图控制器
        //UI应该在主线程显示,否则控制台会报下面的错
        /**
         This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.

         */
        dispatch_async(dispatch_get_main_queue()) {
            vCtrl.presentViewController(alertCtrl, animated: true, completion: nil)
        }
        
        
    }

}


