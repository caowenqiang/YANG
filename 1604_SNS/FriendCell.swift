//
//  FriendCell.swift
//  1604_SNS
//
//  Created by gaokunpeng on 16/9/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var groupLabel: UILabel!
    
    //显示数据
    func configModel(model: FriendModel) {
        
        //1.图片
        let str = String(format: "http://10.0.8.8/sns/my/headimage/php?uid=%@", model.uid!)
        let url = NSURL(string: str)
        userImageView.kf_setImageWithURL(url!)
        
        //2.好友名字
        nameLabel.text = model.username
        
        //3.好友所属的组
        groupLabel.text = model.group
        
        
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
