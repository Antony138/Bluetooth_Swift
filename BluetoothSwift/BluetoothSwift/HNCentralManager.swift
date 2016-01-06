//
//  HNCentralManager.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/5/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit
import CoreBluetooth

let kIUL11ServiceUUID          = CBUUID.init(string: "FF12")
let kCharacteristicDataInUUID  = CBUUID.init(string: "FF01")
let kCharacteristicDataOutUUID = CBUUID.init(string: "FF02")


class HNCentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK:- 属性
    /// CBCentralManager对象
    var bleManager: CBCentralManager!
    
    /// 要将发现的设备放入数组,否则链接不了
    var discoverPeripherals = [CBPeripheral]()
    
    /// 已链接的设备,保存到数组(发送指令的时候要根据不同的设备发送)
    var connectedPeripherals = [CBPeripheral]()
    
    
    // MARK:- 创建单例
    static let sharedManager = HNCentralManager()
    private override init() {
        super.init()
        // 实例化CBCentralManager对象
        bleManager = CBCentralManager.init(delegate: self, queue: nil)
    }

    // MARK:- CBCentralManagerDelegate
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.Unknown:
            print("CBCentralManager: Unknown")
            
        case CBCentralManagerState.Resetting:
            print("CBCentralManager: Resetting")
            
        case CBCentralManagerState.Unsupported:
            print("CBCentralManager: Unsupported")
            
        case CBCentralManagerState.Unauthorized:
            print("CBCentralManager: Unauthorized")
            
        case CBCentralManagerState.PoweredOff:
            print("CBCentralManager: PoweredOff")
            
        case CBCentralManagerState.PoweredOn:
            print("CBCentralManager: PoweredOn")
            // PoweredOn之后才能扫描，否则扫描不出设备(好像其他人的实现又不用？)
            // 开始扫描(在这里就可以通过服务的UUID来过滤扫描到的设备)
            bleManager.scanForPeripheralsWithServices([kIUL11ServiceUUID], options: nil)
            print("开始扫描")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        // kCBAdvDataServiceUUIDs键对应的是一个array(打印中用括号表示的是array，中括号表示的是字典)
//        print("发现设备\(peripheral.name); 广播出来的服务有:\(advertisementData["kCBAdvDataServiceUUIDs"])")
        // 发现设备
        discoverPeripherals.append(peripheral)
        bleManager.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("已经成功链接\(peripheral.name)")
        // 要做的动作:
        // 1、将设备的identifier赋值给light
        // 2、发现服务(只需要发现FF12服务即可)
        // 3、将已经链接的设备加入connectedPeripherals数组
        
        peripheral.delegate = self
        // 发现服务、特征
        peripheral.discoverServices([kIUL11ServiceUUID])
        
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("已经断开链接\(peripheral.name)")
        // 要做的动作
        // TODO:将断开链接的设备从connectedPeripherals数组中删除
        // 1、将断开链接的设备从connectedPeripherals数组中删除
    }
    
    // MARK:- CBPeripheralDelegate
    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
        print("peripheral.RSSI")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("发现设备\(peripheral.services?.count)个服务, 是:\(peripheral.services)")
        // 要做的动作
        // 1、发现特征(IUL11有13个特征,只需要写入数据、读取数据2个特征即可(DataIn、DataOut))
        peripheral.discoverCharacteristics([kCharacteristicDataInUUID, kCharacteristicDataOutUUID], forService: peripheral.services![0])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("发现设备\(service.characteristics?.count)个特征, 是:\(service.characteristics)")
        for characteristic in service.characteristics! {
            switch characteristic.UUID {
            case kCharacteristicDataInUUID:
                print("这是用于数据写入的特征,它的UUID是:\(characteristic.UUID)")
                
            case kCharacteristicDataOutUUID:
                // TODO:监听FF02 DataOut特征
                print("这是用于读取数据的特征,它的UUID是:\(characteristic.UUID)")
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                
            default:
                print("default")
            }
        }
    }
    
    func peripheralDidUpdateName(peripheral: CBPeripheral) {
        print("设备的名字被修改了")
        // 根据设备UUID,更新IUL11 UI(数据模型)的名字
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didUpdateValueFor_Characteristic_")
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didUpdate_Notification_StateForCharacteristic")
    }

}
