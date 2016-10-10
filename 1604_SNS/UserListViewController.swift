//
//  UserListViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class UserListViewController: UIViewController{
    
    //数据源数组
    lazy var dataArray = Array<UserModel>()
    
    //表格
    var tbView: UITableView?
    
    //创建表格
    func createTableView() {
    
        automaticallyAdjustsScrollViewInsets = false
        
        //tbView = UITableView(frame: CGRectMake(0, 64, view.bounds.size.width, view.bounds.size.height-64), style: .Plain)
        
        tbView = UITableView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
        
    }
    
    //下载数据
    func downloadData() {
        
        let urlString = "http://10.0.8.8/sns/my/user_list.php"
        
        Alamofire.request(.GET, urlString).responseJSON {
            [weak self]
            (response) in
            
            switch response.result {
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self!, msg: error.localizedDescription, confirmClosure: nil)
            case .Success:
                
                self!.dataArray = UserModel.parseModel(response.data!)
                //刷新表格
                dispatch_async(dispatch_get_main_queue(), {
                    self!.tbView!.reloadData()
                })
                
            }
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //表格
        createTableView()
        //数据
        downloadData()
        
        view.backgroundColor = UIColor.whiteColor()
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
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "userCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? UserCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("UserCell", owner: nil, options: nil).last as? UserCell
        }
        
        //显示数据
        let model = dataArray[indexPath.row]
        cell?.configModel(model)
        return cell!
    }
    
    
}



