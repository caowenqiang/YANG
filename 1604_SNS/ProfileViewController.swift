//
//  ProfileViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/14.
//  Copyright © 2016年 apple. All rights reserved.
//


/**
 个人信息界面
 */

import UIKit

class ProfileViewController: UIViewController {
    
    //数据
    var profileModel: ProfileModel?
    
    //表格
    var tbView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "个人资料"
        
        //创建表格
        createTableView()
        
        //请求数据
        downloadData()
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    func createTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tbView = UITableView(frame: CGRectMake(0, 64, 375, 667-64), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
    }
    
    //请求数据
    func downloadData() {
        
        //获取登陆成功状态的token值
        let ud = NSUserDefaults.standardUserDefaults()
        let token = ud.objectForKey("uid") as! String
        
        let urlString = "http://10.0.8.8/sns/my/profile.php?uid=" + "\(token)"
        
        SNSSessionDownloader.downloadWithUrlString(urlString, finishClosure: {
            
            [weak self]
            (data) in
            
            //下载成功
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonData.isKindOfClass(NSDictionary) {
                
                let dict = jsonData as! NSDictionary
                //print(dict)
                self?.profileModel = ProfileModel()
                //使用KVC设置属性值
                self?.profileModel?.setValuesForKeysWithDictionary(dict as! Dictionary<String,AnyObject>)
                
                //刷新表格
                //回到主线程刷新
                dispatch_async(dispatch_get_main_queue(), { 
                    self?.tbView?.reloadData()
                })
                
                
            }
            
        }) {
                (error) in
                    MyUtil.showAlert(onViewController: self, msg: "下载失败", confirmClosure: nil)
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
extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if profileModel != nil {
//            return 6
//        }
//        return 0
        
        //下面的写法和上面是等价的
        if profileModel != nil {
            return 6
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if nil == cell {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        //显示数据
        if indexPath.row == 0 {
            
            if let name = profileModel?.username {
                cell?.textLabel?.text = "用户名:\(name)"
            }else{
                cell?.textLabel?.text = "用户名:未填写"
            }
            
        }else if indexPath.row == 1 {
            
            let province = profileModel?.birthprovince
            let city = profileModel?.birthcity
            if (province != nil && city != nil)  {
                cell?.textLabel?.text = "出生地:\(province!)省\(city!)市"
            }else{
                cell?.textLabel?.text = "出生地:未填写"
            }
            
            
        }else if indexPath.row == 2 {
            if let blood = profileModel?.blood {
                cell?.textLabel?.text = "血型:\(blood)"
            }else{
                cell?.textLabel?.text = "血型:未填写"
            }
            
        }else if indexPath.row == 3 {
            
            if let email = profileModel?.email {
                cell?.textLabel?.text = "邮箱:\(email)"
            }else{
                cell?.textLabel?.text = "邮箱:未填写"
            }

        }else if indexPath.row == 4 {
            
            let province = profileModel?.resideprovince
            let city = profileModel?.residecity
            if (province != nil && city != nil)  {
                cell?.textLabel?.text = "居住地:\(province!)省(市)\(city!)市(区)"
            }else{
                cell?.textLabel?.text = "居住地:未填写"
            }
            
        }else if indexPath.row == 5 {
            
            if let imageName = profileModel?.headimage {
                let urlString = "http://10.0.8.8/sns\(imageName)"
                let url = NSURL(string: urlString)
                cell?.imageView?.kf_setImageWithURL(url!)
                
                cell?.selected = true
                cell?.selected = false
            }
            
            
        }
        
        return cell!
    }
    
}



