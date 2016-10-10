//
//  UserCell.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var friendNumLabel: UILabel!
    
    //显示数据
    func configModel(model: UserModel){
        //图片
        let urlString = "http://10.0.8.8/sns\(model.headimage!)"
        let url = NSURL(string: urlString)
        userImageView.kf_setImageWithURL(url!)
        
        //名字
        userName.text = model.username
        
        //好友数量
        friendNumLabel.text = "共有\(model.friendnum!)个好友"
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
