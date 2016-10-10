//
//  SNSDownloader.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

protocol SNSDownloaderDelegate: NSObjectProtocol {
    
    //下载失败
    func downloader(downloader: SNSDownloader,didFailWithError error: NSError)
    //下载成功
    func downloader(downloader: SNSDownloader, didFinishWithData data: NSData)
    
}

//下载的枚举类型
enum DownloaderType: Int {
    case Register = 10   //注册
    case Login           //登陆
}


class SNSDownloader: NSObject {
    
    //代理属性
    //weak
    weak var delegate: SNSDownloaderDelegate?
    
    //下载的类型
    var type: DownloaderType?
    
    //存储下载的二进制数据
    private lazy var receiveData = NSMutableData()
    
    //下载的方法
    func downloadWithUrlString(urlString: String) {
        
        //1.创建NSURL
        let url = NSURL(string: urlString)
        //2.创建NSURLRequest
        let request = NSURLRequest(URL: url!)
        //3.创建NSURLConnection
        let conn = NSURLConnection(request: request, delegate: self)
 
    }
    

}

//MARK: NSURLConnection代理
extension SNSDownloader: NSURLConnectionDelegate,NSURLConnectionDataDelegate {
    
    //下载失败
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        delegate?.downloader(self, didFailWithError: error)
    }
    
    //服务器响应时调用的方法
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        //清空二进制数据
        //如果下载的时候一个SNSDownloader对象对应一次下载，那下面的代码不用写
        receiveData.length = 0
    }
    
    //接收到数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receiveData.appendData(data)
    }
    
    //下载结束
    func connectionDidFinishLoading(connection: NSURLConnection) {
        delegate?.downloader(self, didFinishWithData: receiveData)
    }
    
}


