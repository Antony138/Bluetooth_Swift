//
//  light.swift
//  Lighting Controller
//
//  Created by homni_rd01 on 15/12/5.
//  Copyright © 2015年 Homni Electron Inc. All rights reserved.
//

import Foundation
import UIKit

class Light {
   
    var color:UIColor = UIColor.whiteColor()
    var group:Int = 0 //初始化为没有群组
    var name:String = "center"
    var tag:Int = 0
    
    init(tag:Int,color:UIColor,group:Int,name:String){
        self.tag = tag
        self.color = color
        self.group = group
        self.name = name
        
    }
    
    convenience init(tag:Int){
        self.init(tag:tag,color:UIColor.whiteColor(),group:0,name:"center")
    }
    
    convenience init(tag:Int,color:UIColor){
        self.init(tag:tag,color:color,group:0,name:"center")
        
    }
    
}