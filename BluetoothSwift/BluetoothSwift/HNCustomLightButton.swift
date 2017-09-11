//
//  HNCustomLightButton.swift
//  Lighting Controller
//
//  Created by homni_rd01 on 15/12/3.
//  Copyright © 2015年 Homni Electron Inc. All rights reserved.
//

import UIKit


protocol HNCustomLightButtonDelegate{
    
    func click(_ view:HNCustomLightButton,tag:Int)
    
}

class HNCustomLightButton: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var selectColorView: UIView!
    
    @IBOutlet weak var groupsImageView: UIImageView!
    
    @IBOutlet weak var groupsName: UILabel!
    
    var light:Light?
    
    //默认没有选中
    var selected:Bool = false
    
    var isGroup:Bool = false
    
    var isOn:Bool = false
    
    var isConnect:Bool = false
    
    var groupIndex = 4
    
    var delegate:HNCustomLightButtonDelegate! = nil
    
    //MARK:-设置约束
    func setConstraints(){
        
        if self.superview != nil{
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview!.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0.0)
        let topConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0.0)
        
        self.superview?.addConstraints([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])

        }
    }
    
    //MARK:-设置SelectColorView的背景颜色
    func setLightColor(_ color:UIColor){
       selectColorView.backgroundColor = color
    }
    
    //MARK:-设置GroupsImageView的图片
    func setLightGroup(_ image:UIImage){
      groupsImageView.image = image
    }
    
    //MARK:-设置群组名字
    func setLightName(_ name:String){
       groupsName.text = name
    }
    
    //MARK:-设置View的背景色
    func setViewBackground(_ color:UIColor){
       self.backgroundColor = color
    }
    
    //MARK:-设置View边界的颜色
    func setViewBorderColor(){
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor(red: 0, green: 0.623, blue: 0.909, alpha: 1).cgColor
    }
    
    func setViewNoBorderColor(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.254, green: 0.282, blue: 0.313, alpha: 1).cgColor
    }
    
    //MARK:-设置View的明亮度
    func setViewAlpha(_ value:CGFloat){
      self.alpha = value
    }
    
    //MARK:-根据灯的开关状态设置view的背景亮度
    func setLightButtonBrightness(){
        if self.isConnect {
            
        if self.isOn {
        setViewAlpha(1)
        }else{
        setViewAlpha(0.1)
        }}
        else {
        setViewAlpha(0.1)
        }
    }
    
    //view的选中状态切换
    func toggle() {
        selected = !selected
    }
    

    func setSelectedBackground() {
        //选中时显示蓝色边框
        if selected {
            setViewBorderColor()
        }else{
            setViewNoBorderColor()
        }
    }
    //MARK:-设置选中，同一组时的背景
    func selcetedSameGroupBackground(){
        if selected {
            
        }else{
            toggle()
        }
        setViewBorderColor()
    }
    
    //MARK:-设置没选中时，同一组的背景
    func deSelcetedSameGroupBackground(){
        if selected {
           toggle()
        }else{
            
        }
        setViewNoBorderColor()
    }
    
    //MARK:-设置View的点击事件监听器
    func clickListener(){
        self.isUserInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HNCustomLightButton.clickAction))
        self.addGestureRecognizer(singleTap)
        
//        print("superview tag\(self.superview?.tag)")
        
    }
    
    //MARK:-设置View的点击事件
    func clickAction(){
        if self.isConnect {
            toggle()
            setSelectedBackground()
            delegate.click(self, tag: (self.superview?.tag)!)
        }
    }
    
    
    
}
