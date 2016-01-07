//
//  HNIUL11Manager.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/7/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNIUL11Manager: NSObject {
    
    var centeralManager: HNCentralManager!
    var store: HNIUL11Store!
    
    // MARK:- Create Sinaleton/创建单例
    static let shareManager = HNIUL11Manager()
    private override init() {
        super.init()
        centeralManager = HNCentralManager.init()
        store = HNIUL11Store.init()
    }
}
