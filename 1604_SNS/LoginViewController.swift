//
//  LoginViewController.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

/*
 注册、登陆界面
 */

import UIKit

class LoginViewController: UIViewController {
    
    //用户名
    var nameTextField: UITextField?
    //密码
    var pwdTextField: UITextField?
    //邮箱
    var emailTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //1.用户名
        let nameLabel = MyUtil.createLabel(CGRectMake(40, 100, 80, 40), text: "用户名:")
        nameTextField = MyUtil.createTextField(CGRectMake(140, 100, 200, 40), placeHolder: "请输入用户名", isPwd: false)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField!)
        
        //2.密码
        let pwdLabel = MyUtil.createLabel(CGRectMake(40, 160, 80, 40), text: "密码:")
        pwdTextField = MyUtil.createTextField(CGRectMake(140, 160, 200, 40), placeHolder: "请输入密码", isPwd: true)
        view.addSubview(pwdLabel)
        view.addSubview(pwdTextField!)
        
        //3.邮箱
        let emailLabel = MyUtil.createLabel(CGRectMake(40, 220, 80, 40), text: "邮箱:")
        emailTextField = MyUtil.createTextField(CGRectMake(140, 220, 200, 40), placeHolder: "请输入邮箱", isPwd: false)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField!)
        
        
        //注册按钮
        let registerBtn = MyUtil.createBtn(CGRectMake(80, 300, 60, 40), title: "注册", target: self, action: #selector(registerAction))
        
        //登陆按钮
        let loginBtn = MyUtil.createBtn(CGRectMake(240, 300, 60, 40), title: "登陆", target: self, action: #selector(loginAction))
        view.addSubview(registerBtn)
        view.addSubview(loginBtn)
        
        view.backgroundColor = UIColor.whiteColor()
        
        //测试代码
        nameTextField?.text = "gkp307"
        pwdTextField?.text = "05513867720"
        
    }
    
    //注册功能
    func registerAction(){
    
        // http://10.0.8.8/sns/my/register.php?username=zs&password=123456&email=zs@163.com
        
       
        if (nameTextField?.text != "") &&  (pwdTextField?.text != "") && (emailTextField?.text != "") {
            
            // 格式控制符: 可以在字符串里面加一个变量
            // %d / %zd  -> Int
            // %ld -> NSInteger
            // %f -> Float
            // %lf -> Double
            // %@ -> 其他对象类型
            
            //将中文字符进行编码
            //这个方法已经弃用，用下面的方法代替
            //let name = (nameTextField?.text)!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let name = (nameTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let pwd = (pwdTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let email = (emailTextField?.text)?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            let urlString = String(format: "http://10.0.8.8/sns/my/register.php?username=%@&password=%@&email=%@", name!, pwd!, email!)
            
            let downloader = SNSDownloader()
            downloader.delegate = self
            
            downloader.type = .Register
            
            downloader.downloadWithUrlString(urlString)
        }else {
            
            //提示
            MyUtil.showAlert(onViewController: self, msg: "用户名、密码或者邮箱不能为空", confirmClosure: nil)
            //showAlert("用户名、密码或者邮箱不能为空", confirmClosure: nil)
        }

    }
    
    
    
    
    //登陆功能
    func loginAction(){
        
        if self.nameTextField?.text == "" || self.pwdTextField?.text == "" {
            
            MyUtil.showAlert(onViewController: self, msg: "用户名和密码不能为空", confirmClosure: nil)
            //showAlert("用户名和密码不能为空", confirmClosure: nil)
            return
        }
    
        //如果有中文，将中文编码
        let name = self.nameTextField?.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let pwd = self.pwdTextField?.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlString = String(format: "http://10.0.8.8/sns/my/login.php?username=%@&password=%@", name!, pwd!)
        //网络请求
        let downloader = SNSDownloader()
        downloader.delegate = self
        
        downloader.type = .Login
        
        downloader.downloadWithUrlString(urlString)
        
        
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

//MARK: SNSDownloader代理
extension LoginViewController: SNSDownloaderDelegate {
    
    func downloader(downloader: SNSDownloader, didFailWithError error: NSError) {
        
        if downloader.type == .Register {
            MyUtil.showAlert(onViewController: self, msg: "注册失败", confirmClosure: nil)
            //showAlert("注册失败", confirmClosure: nil)
        }else{
            MyUtil.showAlert(onViewController: self, msg: "登陆失败", confirmClosure: nil)
            //showAlert("登陆失败", confirmClosure: nil)
        }
        
        
    }
    
    func downloader(downloader: SNSDownloader, didFinishWithData data: NSData) {
        
        if downloader.type == .Register {
            //注册
            
            //JSON解析
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonData.isKindOfClass(NSDictionary) {
                let dict = jsonData as! Dictionary<String,AnyObject>
                
                let msg = dict["message"] as! String
                
                let code = dict["code"] as! String
                if code == "registered" {
                    //注册成功
                    MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                    //showAlert(msg, confirmClosure: nil)
                }else{
                    //注册失败
                    MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                    //showAlert(msg, confirmClosure: nil)
                }
                
            }

            
        }
        else if downloader.type == .Login {
            //登陆
            let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonData.isKindOfClass(NSDictionary) {
                let dict = jsonData as! Dictionary<String,AnyObject>
                
                let code = dict["code"] as! String
                let msg = dict["message"] as! String
                
                if code == "login_success" {
                    //登陆成功
                    
                    //存储token值
                    let token = dict["m_auth"] as! String
                    let uid = dict["uid"] as! String
                    
                   // print("m_auth=\(token), uid=\(uid)")
                    
                    let ud = NSUserDefaults.standardUserDefaults()
                    ud.setObject(token, forKey: "m_auth")
                    ud.setObject(uid, forKey: "uid")
                    ud.synchronize()
                    
                    
                    MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: {
                        [weak self] in
                        //跳转主界面
                        let rootCtrl = RootViewController()
                        self!.navigationController?.pushViewController(rootCtrl, animated: true)
                    })
                    
                    /*showAlert(msg){
                        
                        [weak self] in
                        //跳转主界面
                        let rootCtrl = RootViewController()
                        self!.navigationController?.pushViewController(rootCtrl, animated: true)
 
                    }*/
                    
                    
                    
                    
                }else{
                    MyUtil.showAlert(onViewController: self, msg: msg, confirmClosure: nil)
                    //showAlert(msg, confirmClosure: nil)
                }
                
            }
            
            
            
            
        }
        
        
    }
    
}



