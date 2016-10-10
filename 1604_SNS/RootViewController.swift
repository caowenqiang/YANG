//
//  RootViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

/*
 主页
 */

import UIKit

import Alamofire

class RootViewController: UIViewController {
    
    //数据源数组
    lazy var dataArray = ["个人资料", "注销", "好友列表", "上传头像" ,"获取头像", "公开用户列表", "相册列表"]
    
    //表格
    var tbView: UITableView?
    
    //创建表格
    func createTableView() {
        
        automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 375, 667-64), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "主页"
        
        //表格
        createTableView()
        
        //view.backgroundColor = UIColor.redColor()
        
    }
    
    
    //注销操作
    func logout() {
        
        /*
         http://10.0.8.8/sns/my/logout.php?uid=417
         */
        
        let downloader = SNSSessionDownloader()
        //设置代理
        downloader.delegate = self
        //请求
        let ud = NSUserDefaults.standardUserDefaults()
        let uidToken = ud.objectForKey("uid") as! String
        
        downloader.postWithUrlString("http://10.0.8.8/sns/my/logout.php", parameters: ["uid": uidToken])
    }
    
    
    //上传头像
    func uploadHeadImage() {
        
        /*
         第一个参数:GET/POST
         第二个参数:网址
         第三个参数:文件数据
         第四个参数:请求返回时调用的闭包
         */
        
        Alamofire.upload(.POST, "http://10.0.8.8/sns/my/upload_headimage.php", multipartFormData: {
            (formData) in
            
                //1、用户token值
                let ud = NSUserDefaults.standardUserDefaults()
                let uid = ud.objectForKey("uid") as! String
                //字符串转二进制
                let uidData = uid.dataUsingEncoding(NSUTF8StringEncoding)
                formData.appendBodyPart(data: uidData!, name: "uid")
            
               //2.图片
            /*
             第一个参数:图片的数据
             第二个参数:key值
             第三个参数:类型(image/png)
             */
            
            let path = NSBundle.mainBundle().pathForResource("1604", ofType: "png")
            //下面的写法和上面的作用是一样的
            //let path = NSBundle.mainBundle().pathForResource("1604.png", ofType: nil)
            let data = NSData(contentsOfFile: path!)
            
            formData.appendBodyPart(data: data!, name: "headimage", fileName: "newFile", mimeType: "image/png")
//            formData.appendBodyPart(data: data!, name: "headimage", mimeType: "image/png")
            
            
            }) { (dataEncoding) in
                
                switch dataEncoding {
                case .Failure(let error):
                    print(error)
                    MyUtil.showAlert(onViewController: self, msg: "上传失败", confirmClosure: nil)
                case .Success(let request,_,_):
                    request.responseJSON(completionHandler: { (response) in
                        
                        switch response.result {
                        case .Failure(let err):
                            print(err)
                            MyUtil.showAlert(onViewController: self, msg: "上传失败", confirmClosure: nil)
                        case .Success(let jsonData):
                            
                            let dict = jsonData as! Dictionary<String,AnyObject>
                            let code = dict["code"] as! String
                            let msg = dict["message"] as! String
                            if code == "upload_file_ok" {
                                MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                            }else{
                                MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                            }
                            
                        }
                        
                        
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


//MARK: UITableView代理
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if nil == cell {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)            
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        
        return cell!
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            //个人资料
            let ctrl = ProfileViewController()
            //navigationController?.pushViewController(ctrl, animated: true)
            //跟上面的是等价的
            navigationController?.showViewController(ctrl, sender: nil)
        }
        else if indexPath.row == 1 {
            //注销
            logout()
        }else if indexPath.row == 2 {
            //好友列表
            let friendCtrl = FriendListViewController()
            navigationController?.pushViewController(friendCtrl, animated: true)
        }else if indexPath.row == 3 {
            
            //上传头像
            uploadHeadImage()
            
        }
        else if indexPath.row == 4 {
            //获取头像
            let headImageCtrl = HeadImageViewController()
            navigationController?.pushViewController(headImageCtrl, animated: true)
        }else if indexPath.row == 5 {
            //公开用户列表
            
            let userListCtrl = UserListViewController()
            navigationController?.pushViewController(userListCtrl, animated: true)
        }else if indexPath.row == 6 {
            
            //相册列表
            let albumListCtrl = AlbumListViewController()
            navigationController?.pushViewController(albumListCtrl, animated: true)
            
        }
        
    }
    
}


//MARK: SNSSessionDownloader代理
extension RootViewController: SNSSessionDownloaderDelegate {
    
    func sessionDownloader(downloader: SNSSessionDownloader, didFailWithError error: NSError) {
        MyUtil.showAlert(onViewController: self, msg: "注销失败", confirmClosure: nil)
    }
    
    func sessionDownloader(downloader: SNSSessionDownloader, didFinishWithData data: NSData) {
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if jsonData.isKindOfClass(NSDictionary) {
            
            let dict = jsonData as! Dictionary<String,AnyObject>
            
            let code = dict["code"] as! String
            let msg = dict["message"] as! String
            
            if code == "security_exit" {
                //注销成功
                
                MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: {
                    [weak self] in
                    //退到前面的界面
                    self!.navigationController?.popViewControllerAnimated(true)
                    
                    //清除token值
                    let ud = NSUserDefaults.standardUserDefaults()
                    ud.removeObjectForKey("m_auth")
                    ud.removeObjectForKey("uid")
                    //同步到文件
                    ud.synchronize()
                    
                })
                
            }else{
                //注销失败
                MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
            }
            
            
            
        }
        
        
    }
    
}




