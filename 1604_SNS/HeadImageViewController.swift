//
//  HeadImageViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON


class HeadImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.whiteColor()
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        
        let urlString = String(format: "http://10.0.8.8/sns/my/headimage.php?size=big&uid=%@", uid)
        
        //请求头像数据
        Alamofire.request(.GET, urlString).responseData {
            (response) in
            switch response.result {
            case .Failure(let error):
                print(error)
            case .Success:
                let data = response.data
                
                //显示成图片
                dispatch_async(dispatch_get_main_queue(), {
                    let image = UIImage(data: data!)
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRectMake(60, 100, (image?.size.width)!, (image?.size.height)!)
                    self.view.addSubview(imageView)
                })
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
