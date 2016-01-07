//
//  HNIUL11Store.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/7/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNIUL11Store: NSObject {
    
    /// 所有灯的数据
    var allLights: [HNLight]! {
        // Swift中的get、set方法，跟在属性定义后面
        get {
            return privateLights
        }
    }
    
    /// 返回已经链接设备的数量
    var connectedLightTotal: Int {
        set {
            self.connectedLightTotal = 0
            for light in privateLights! {
                if light.isConnected {
                    self.connectedLightTotal++
                }
            }
        }
        get {
            return self.connectedLightTotal
        }
    }
    
    /// 私有的灯数据
    private var privateLights: [HNLight]?
    
    
    override init() {
        super.init()
        // 从沙盒中取数据
        privateLights = NSKeyedUnarchiver.unarchiveObjectWithFile(self.dataArchivePath()) as? [HNLight]
        print("\(self.dataArchivePath())")
        
        // 沙盒中没有数据,创建之
        if (privateLights == nil) {
            for _ in 0...7 {
                let light = HNLight.init()
                privateLights?.append(light)
            }
        }
    }
    
    // 保存数据的路径
    func dataArchivePath() -> String {
        // 可以将NSSearchPathDirectory、NSSearchPathDomainMask删除
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let doucumentDirectory = documentDirectories.first!
        return doucumentDirectory.stringByAppendingString("lightingControllerData.archive")
    }
    
    // MARK:保存数据
    func saveData() -> Bool {
        return NSKeyedArchiver.archiveRootObject(privateLights!, toFile: self.dataArchivePath())
    }
}
