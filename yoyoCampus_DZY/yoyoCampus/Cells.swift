//
//  Cells.swift
//  yoyoCampus
//
//  Created by DuZhiXia on 15/9/15.
//  Copyright © 2015年 DuZhiXia. All rights reserved.
//

import UIKit

///设置界面中的cell
class SettingCell: UITableViewCell {
    var icon = UIImageView()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon.frame = CGRect(x: 20 * Consts.ratio, y: 20 * Consts.ratio, width: 64 * Consts.ratio, height: 64 * Consts.ratio)
        self.icon.image = Consts.imageFromColor(UIColor.orangeColor(), size: self.icon.frame.size)
        self.addSubview(self.icon)
        
        self.label.text = "test"
        self.label.font = Consts.ft15
        self.label.textColor = Consts.lightGray
        self.label.sizeToFit()
        self.label.center = CGPoint(x: self.icon.frame.maxX + 40 * Consts.ratio + self.label.frame.width / 2, y: self.icon.center.y)
        self.addSubview(self.label)
        self.accessoryType = .DisclosureIndicator
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.icon.frame.maxY + 20 * Consts.ratio)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///发布商品中的cell-icon和textField
class UploadGoodsCell1 : UITableViewCell {
    var icon = UIImageView()
    var input = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 32 * Consts.ratio, height: 32 * Consts.ratio)
        self.icon.contentMode = .ScaleAspectFit
        self.addSubview(self.icon)
        
        self.input.bounds = CGRect(x: 0, y: 0, width: self.frame.width - self.icon.frame.maxX - 22 * Consts.ratio, height: Consts.hoFt13)
        self.input.frame.origin.x = self.icon.frame.maxX + 22 * Consts.ratio
        self.input.center.y = self.icon.center.y
        self.input.font = Consts.ft13
        self.input.textColor = Consts.lightGray
        self.addSubview(self.input)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.icon.frame.maxY + 24 * Consts.ratio)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///发布商品中的cell-icon和textView
class UploadGoodsCell2 : ACEExpandableTextCell {
    var icon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 32 * Consts.ratio, height: 32 * Consts.ratio)
        self.icon.contentMode = .ScaleAspectFit
        self.icon.image = Consts.imageFromColor(Consts.tintGreen, size: self.icon.frame.size)
        self.addSubview(self.icon)
        
        self.textView.placeholder = "详情描述(请在这里输入不少于10个字)"
        self.textView.bounds = CGRect(x: 0, y: 0, width: self.frame.width - self.icon.frame.maxX - 22 * Consts.ratio, height: 262 * Consts.ratio)
        self.textView.frame.origin.x = self.icon.frame.maxX + 13 * Consts.ratio
        self.textView.frame.origin.y = self.icon.frame.origin.y - 12 * Consts.ratio
        self.textView.font = Consts.ft13
        self.textView.textColor = Consts.lightGray
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.textView.frame.maxY + 24 * Consts.ratio)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///发布商品中的cell-icon和button
class UploadGoodsCell3 : UITableViewCell {
    var icon = UIImageView()
    var btn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.icon.frame = CGRect(x: 40 * Consts.ratio, y: 24 * Consts.ratio, width: 32 * Consts.ratio, height: 32 * Consts.ratio)
        self.icon.contentMode = .ScaleAspectFit
        self.icon.image = Consts.imageFromColor(Consts.tintGreen, size: self.icon.frame.size)
        self.addSubview(self.icon)
        
        self.btn.bounds = CGRect(x: 0, y: 0, width: self.frame.width - self.icon.frame.maxX - 22 * Consts.ratio, height: Consts.hoFt13)
        self.btn.frame.origin.x = self.icon.frame.maxX + 22 * Consts.ratio
        self.btn.center.y = self.icon.center.y
        self.btn.contentHorizontalAlignment = .Left
        self.btn.titleLabel?.font = Consts.ft13
        self.btn.setTitleColor(Consts.lightGray, forState: .Normal)
        self.addSubview(self.btn)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.icon.frame.maxY + 24 * Consts.ratio)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///发布商品中的cell-大button和label
class UploadGoodsCell4 : UITableViewCell {
    var img = UIButton()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.img.frame = CGRect(x: 230 * Consts.ratio, y: 30 * Consts.ratio, width: 138 * Consts.ratio, height: 138 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.setImage(Consts.imageFromColor(Consts.tintGreen, size: self.img.frame.size), forState: .Normal)
        self.addSubview(self.img)
        
        self.label = Consts.setUpLabel("点击添加商品图片", color: Consts.lightGray, font: Consts.ft13, x: 0, y: self.img.frame.maxY + 20 * Consts.ratio, centerX: self.img.center.x)
        self.addSubview(self.label)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.label.frame.maxY + 32 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///个人中心的cell
class PersonalCenterCell1 : UITableViewCell {
    var icon = UIImageView()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon.frame = CGRect(x: 80 * Consts.ratio, y: 20 * Consts.ratio, width: 35 * Consts.ratio, height: 25 * Consts.ratio)
        self.icon.image = Consts.imageFromColor(UIColor.orangeColor(), size: self.icon.frame.size)
        self.addSubview(self.icon)
        
        self.label.text = "test"
        self.label.font = Consts.ft15
        self.label.textColor = Consts.lightGray
        self.label.sizeToFit()
        self.label.center = CGPoint(x: self.icon.frame.maxX + 30 * Consts.ratio + self.label.frame.width / 2, y: self.icon.center.y)
        self.addSubview(self.label)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.icon.frame.maxY + 20 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///发布商品中的cell-大button和label
class PersonCenterCell2 : UITableViewCell {
    var img = UIImageView()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.img.frame = CGRect(x: 280 * Consts.ratio, y: 50 * Consts.ratio, width: 160 * Consts.ratio, height: 160 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = self.img.frame.width / 2
        self.img.layer.masksToBounds = true
        self.img.image = Consts.imageFromColor(Consts.tintGreen, size: self.img.frame.size)
        self.addSubview(self.img)
        
        self.label = Consts.setUpLabel("点击添加商品图片", color: Consts.lightGray, font: Consts.ft15, x: 0, y: self.img.frame.maxY + 36 * Consts.ratio, centerX: self.img.center.x)
        self.addSubview(self.label)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.label.frame.maxY + 20 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///个人信息中的cell-label和image
class PersonInfomationCell1 : UITableViewCell {
    var label = UILabel()
    var img = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.img.frame = CGRect(x: 280 * Consts.ratio, y: 20 * Consts.ratio, width: 160 * Consts.ratio, height: 160 * Consts.ratio)
        self.img.center.x = self.frame.width / 2
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = self.img.frame.width / 2
        self.img.layer.masksToBounds = true
        self.img.image = Consts.imageFromColor(UIColor.orangeColor(), size: self.img.frame.size)
        self.addSubview(self.img)
        
        self.label = Consts.setUpLabel("头像", color: Consts.lightGray, font: Consts.ft15, x: 30 * Consts.ratio, y: self.img.center.y - Consts.hoFt15 / 2, centerX: nil)
        self.addSubview(self.label)
        
        self.accessoryType = .DisclosureIndicator
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.img.frame.maxY + 20 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///个人信息中的cell-两个label
class PersonInfomationCell2 : UITableViewCell {
    var label1 = UILabel()
    var label2 = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        
        self.label1 = Consts.setUpLabel("昵称", color: Consts.lightGray, font: Consts.ft15, x: 30 * Consts.ratio, y: 20 * Consts.ratio, centerX: nil)
        self.addSubview(self.label1)
        
        self.label2 = Consts.setUpLabel("用户昵称", color: Consts.lightGray, font: Consts.ft15, x: 280 * Consts.ratio, y: self.label1.frame.minY, centerX: nil)
        self.addSubview(self.label2)
        
        self.accessoryType = .DisclosureIndicator
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.label1.frame.maxY + 20 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///个人信息中的cell-img和label
class PersonInfomationCell3 : UITableViewCell {
    var img = UIImageView()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.img.frame = CGRect(x: 30 * Consts.ratio, y: 10 * Consts.ratio, width: 50 * Consts.ratio, height: 50 * Consts.ratio)
        self.img.contentMode = .ScaleAspectFit
        self.img.layer.cornerRadius = Consts.radius
        self.img.layer.masksToBounds = true
        self.img.image = Consts.imageFromColor(UIColor.orangeColor(), size: self.img.frame.size)
        self.addSubview(self.img)
        
        self.label = Consts.setUpLabel("绑定", color: Consts.lightGray, font: Consts.ft15, x: 0, y: 20 * Consts.ratio, centerX: nil)
        self.label.frame.origin.x = self.frame.width - self.label.frame.width - 20 * Consts.ratio
        self.label.center.y = self.img.center.y
        self.addSubview(self.label)

        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.img.frame.maxY + 10 * Consts.ratio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}