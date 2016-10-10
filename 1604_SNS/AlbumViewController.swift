//
//  AlbumViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class AlbumViewController: UITableViewController {
    
    //相册的id
    var albumId: String?
    
    //数据源数组
    lazy var dataArray = [PhotoModel]()
    
    //请求数据
    func downloadData() {
        
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        let urlString = String(format: "http://10.0.8.8/sns/my/photo_list.php?uid=%@&id=%@", uid, albumId!)
        
        Alamofire.request(.GET, urlString).responseJSON {
            (response) in
            switch response.result {
            case .Failure(let error):
                MyUtil.showAlert(onViewController: self, msg: error.description, confirmClosure: nil)
            case .Success(let jsonValue):
                
                self.dataArray = PhotoModel.parserModel(jsonValue as! NSDictionary)
                
                //刷新表格
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        }
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        downloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //下载
        downloadData()
        //
        let rightBtn = UIBarButtonItem(title: "上传图片", style: .Done, target: self, action: #selector(uploadImage))
        navigationItem.rightBarButtonItem = rightBtn
    }
    //
    func uploadImage(){
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as!  String
        let urlString = String(format: "http://10.0.8.8/sns/my/upload_rhoto.php?uid=%@&albumid=%@", uid,albumId!)
        Alamofire.upload(.POST,urlString, multipartFormData: { (formData) in
            let path = NSBundle.mainBundle().pathForResource("10_2", ofType: "jpg")
            let data = NSData(contentsOfURL: path!)
            formData.appendBodyPart(data: data!, name: "attach",fileName:"10_2.jpg",mimeType: "image/jpeg")
            
        
        }) { (result) in
                switch result{
                case .Failure(let error):
                    print(error)
                    MyUtil.showAlert(onViewController: self, msg: "上传失败", confirmClosure: nil)
                case .Success(let request,_,_):
                    request.responseJSON(completionHandler: { (response) in
                        let str = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                        
                        let json = JSON(data:response.data!)
                        let code = json["code"].string
                        let msg = json["message"].string
                        if code == "do_success"{
                            self.downloadData()
                        }
                        MyUtil.showAlert(onViewController:self, msg: msg!, confirmClosure: nil)
                    })
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableView代理
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if nil == cell {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        //显示数据
        let model = dataArray[indexPath.row]
        let urlString = String(format: "http://10.0.8.8/sns/%@", model.pic_origin!)
        let url = NSURL(string: urlString)
        cell?.imageView?.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "1604.png"))
        cell?.textLabel?.text = model.title
        
        return cell!
    
    }
    
    
    

}



