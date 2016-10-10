//
//  AlbumListViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire

class AlbumListViewController: UIViewController {
    //数据源
    lazy var dataArray = [Album]()
    //表格
    var tbView: UITableView?
    
    //下载数据
    func downloadData() {
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        
        let urlString = String(format: "http://10.0.8.8/sns/my/album_list.php?uid=%@", uid)
        Alamofire.request(.GET, urlString).responseJSON {
            (response) in
            switch response.result {
            case .Failure(let error):
                //请求失败
                MyUtil.showAlert(onViewController: self, msg: error.localizedDescription, confirmClosure: nil)
            case .Success(let jsonValue):
                //JSON解析
                self.dataArray = Album.parseModel(jsonValue as! NSDictionary)
                
                //刷新表格
                dispatch_async(dispatch_get_main_queue(), {
                    self.tbView?.reloadData()
                })
                
            }
        }
        
        
    }
    
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
        
        //表格
        createTableView()

        //下载数据
        downloadData()
        
        //创建新相册按钮
        let barBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNewAblum))
        navigationItem.rightBarButtonItem = barBtn
    }
    
    //创建新相册
    //albumName->相册名字
    func createAlbum(albumName: String) {
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        
        let urlString = String(format: "http://10.0.8.8/sns/my/create_album.php?uid=%@&albumname=%@&privacy=0", uid, albumName)
        
        Alamofire.request(.GET, urlString).responseJSON {
            (response) in
            switch response.result {
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self, msg: error.localizedDescription, confirmClosure: nil)
            case .Success(let jsonValue):
                let dict = jsonValue as! Dictionary<String,AnyObject>
                let code = dict["code"] as! String
                let msg = dict["message"] as! String
                
                MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                if code == "do_success" {
                    //重新请求数据
                    self.downloadData()
                }
            }
        }
        
        
        
    }
    
    
    //
    func addNewAblum() {
        
        let alertCtrl = UIAlertController(title: "请输入相册名", message: nil, preferredStyle: .Alert)
        
        //添加输入框
        alertCtrl.addTextFieldWithConfigurationHandler {
            (textField) in
            
            //textField.placeholder = "相册名"
            textField.text = "新建相册"
        }
        
        //确定按钮
        let confirmAction = UIAlertAction(title: "确定", style: .Default) {
            (action) in
            
            //发送请求
            let textField = alertCtrl.textFields?.last
            self.createAlbum(textField!.text!)
            
        }
        alertCtrl.addAction(confirmAction)
        
        //取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive) {
            (action) in
            print("取消")
        }
        alertCtrl.addAction(cancelAction)
        
        //显示
        presentViewController(alertCtrl, animated: true, completion: nil)
        
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
extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if nil == cell {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
        }
        
        //数据
        let model = dataArray[indexPath.row]
        cell?.textLabel?.text = model.albumname
        cell?.detailTextLabel?.text = "共有\(model.pics!)张图片"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row]
        //进入某一个相册的图片列表
        let albumCtrl = AlbumViewController()
        albumCtrl.albumId = model.id
        
        navigationController?.pushViewController(albumCtrl, animated: true)
        
    }
    
}



