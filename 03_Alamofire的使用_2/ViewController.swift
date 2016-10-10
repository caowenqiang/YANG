//
//  ViewController.swift
//  03_Alamofire的使用_2
//
//  Created by gaokunpeng on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Alamofire的使用
        let urlString = "http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1"
        
        //Swift的方法调用是，如果最后一个参数是闭包，这个闭包可以写到方法的外面
        Alamofire.request(.GET, urlString).responseJSON {
            //Response类型的对象
            (response) in
            /*
            //请求对象
            print(response.request)
            //响应对象
            print(response.response)
            //请求返回的数据
            print(response.data!)
            //返回的结果对象
            print(response.result)
            */
            
            switch response.result {
            case .Failure(let error):
                //下载失败
                print(error)
            case .Success:
                //下载成功
                let str = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                print(str)
            }
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

