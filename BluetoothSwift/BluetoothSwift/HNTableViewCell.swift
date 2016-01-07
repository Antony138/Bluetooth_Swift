//
//  HNTableViewCell.swift
//  Lighting Controller
//
//  Created by dong on 15/12/6.
//  Copyright © 2015年 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNTableViewCell: UITableViewCell {

    @IBOutlet weak var lightName: UITextField!
    
    @IBOutlet weak var lightColorView: UIView!
    
    @IBOutlet weak var lightGroupImageView: UIImageView!
    
    @IBOutlet weak var contentBackgroundView: UIView!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置选中时的背景
        let selectedBackgroundView = UIView()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            selectedBackgroundView.backgroundColor = UIColor(red: 0.650, green: 0.760, blue: 0.262, alpha: 0.1)
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            selectedBackgroundView.backgroundColor = UIColor(red: 0.650, green: 0.760, blue: 0.262, alpha: 1.0)
        }
        
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    // Class 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = UIColor.blueColor()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    //MARK:-选中时的背景
    func setSelectedBackground(){
        
       contentBackgroundView.backgroundColor = UIColor(red: 0.650, green: 0.760, blue: 0.262, alpha: 0.5)
        
    }
    
    
    
    //    CSDN上查的
    //    添加如下构造函数 (普通初始化)
    //    override  init() { }
    //    如果控制器需要通过xib加载，则需要添加
    //    required init(coder aDecoder: NSCoder) {}
}
