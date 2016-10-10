//
//  SNSSessionDownloader.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol SNSSessionDownloaderDelegate: NSObjectProtocol {
    
    //下载失败
    func sessionDownloader(downloader: SNSSessionDownloader, didFailWithError error: NSError)
    //下载成功
    func sessionDownloader(downloader: SNSSessionDownloader, didFinishWithData data: NSData)
    
}


class SNSSessionDownloader: NSObject {
    
    //代理属性
    weak var delegate: SNSSessionDownloaderDelegate?
    
    
    //POST请求，用代理处理返回的数据
    func postWithUrlString(urlString: String,parameters: [String: AnyObject]?){
        
        //1.NSURL
        let url = NSURL(string: urlString)
        
        //2.request
        let request = NSMutableURLRequest(URL: url!)
        
        /*
         dict == ["name":"zs","age":20,gender:"male"]
         str == "name=zs&age=20&gender=male"
         */
        
        request.HTTPMethod = "POST"
        
        if let param = parameters {
            var str = String()
            
            //遍历字典的键值对
            for (key, value) in param {

                let tmpValue = value as! NSObject
                
                if str.characters.count == 0 {
                    //如果是第一个，前面不加&
                    str = str.stringByAppendingFormat("%@=%@", key, tmpValue)
                }else{
                    //第二个开始，前面加&
                    //str.stringByAppendingString("dasdasd")
                    str = str.stringByAppendingFormat("&%@=%@", key, tmpValue)
                }
            }
            
            print(str)
            
            //转换成二进制
            let data = str.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
            
        }
        
        
        
        
        
        //3.session
        let session = NSURLSession.sharedSession()
        
        //4.task
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if let tmpError = error {
                //出错
                //这里的错误一般是网络有问题或者是网址写错了
                self.delegate?.sessionDownloader(self, didFailWithError: tmpError)
            }else{
                let httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    //成功
                    self.delegate?.sessionDownloader(self, didFinishWithData: data!)
                }else{
                    //失败
                    let myError = NSError(domain: urlString, code: httpResponse.statusCode, userInfo: ["msg":"下载失败"])
                    self.delegate?.sessionDownloader(self, didFailWithError: myError)
                }
            }
            
        }
        
        //5.开启任务
        task.resume()
        
        
        
    }
    
    
    
    
    
    
    
    
    //闭包封装的下载方法
    //var finishClosure: (NSData -> Void)?
    //var failClosure: (NSError -> Void)?
    
    class func downloadWithUrlString(urlString: String, finishClosure: (NSData -> Void), failClosure: (NSError -> Void)) {
        
        //1.创建NSURL对象
        let url = NSURL(string: urlString)
        //2.创建NSURLRequest对象
        let request = NSURLRequest(URL: url!)
        //3.创建NSURLSession
        let session = NSURLSession.sharedSession()
        //4.创建NSURLSessionDataTask
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if let tmpError = error {
                //下载出错
                failClosure(tmpError)
            }else{
                
                let httpReponse = response as! NSHTTPURLResponse
                if httpReponse.statusCode == 200 {
                    //下载数据完成
                    finishClosure(data!)
                }else{
                    let myError = NSError(domain: urlString, code: httpReponse.statusCode, userInfo: ["msg": "下载失败"])
                    failClosure(myError)
                }
                
            }
            
        }
        
        //5.开启任务
        task.resume()
        
        
    }
    
    

}
