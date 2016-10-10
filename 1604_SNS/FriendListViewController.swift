//
//  FriendListViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

/**
 好友列表界面
 */
class FriendListViewController: UIViewController {
    
    //数据源数组
    lazy var dataArray = Array<FriendModel>()
    
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
        
        //创建表格
        createTableView()
        
        //下载数据
        downloadData()
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    //请求数据
    func downloadData() {
    
        //token值
        let ud = NSUserDefaults.standardUserDefaults()
        let uidToken = ud.objectForKey("uid") as! String
        /*
         m_auth比uid更好,更安全
         uid跟用户是一一对应的
         m_auth一般是变化的
         */
        
        Alamofire.request(.POST, "http://10.0.8.8/sns/my/friend.php", parameters: ["uid": uidToken], encoding: ParameterEncoding.URL, headers: nil).responseJSON {
            
            [weak self]
            
            (response) in
            
            if self == nil {
                return
            }
            
            switch response.result {
            case .Failure(let error):
                //失败
                //MyUtil.showAlert(onViewController: self, msg: "请求失败", confirmClosure: nil)
                MyUtil.showAlert(onViewController: self!, msg: error.description, confirmClosure: nil)
                
            case .Success(let jsonData):
                
                let json = JSON(jsonData)
                //json是一个字典
                for (_, value) in json {
                    
                    //创建模型对象
                    let model = FriendModel()
                    model.group = value["group"].string
                    model.groupid = value["groupid"].string
                    model.lastactivity = value["lastactivity"].number
                    model.uid = value["uid"].string
                    model.username = value["username"].string
                    self!.dataArray.append(model)
                }
                
//                //验证数据
//                for model in self!.dataArray {
//                    print(model.username!)
//                }
                
                //刷新表格
                dispatch_async(dispatch_get_main_queue(), {
                    [weak self] in
                    
                    self!.tbView!.reloadData()
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
extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "friendCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FriendCell
        if nil == cell {
            //FriendCell.xib -> FriendCell
            cell = NSBundle.mainBundle().loadNibNamed("FriendCell", owner: nil, options: nil).last as? FriendCell
//            print("\(indexPath.row)")
        }
        
        //显示数据
        let model = dataArray[indexPath.row]
        cell?.configModel(model)
        return cell!
    }
    
}

