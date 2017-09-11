//
//  HNCentralManager.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/5/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit
import CoreBluetooth

/// Our Devices name:IUL11
let kIUL11ServiceUUID          = CBUUID.init(string: "FF12")
/// DataIn Characteristic UUID
let kCharacteristicDataInUUID  = CBUUID.init(string: "FF01")
/// DataOut Characteristic UUID
let kCharacteristicDataOutUUID = CBUUID.init(string: "FF02")
/// scan time(扫描设置5秒)
let scanTime                   = 5.0

class HNCentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK:- Properties/属性
    /// CBCentralManager对象
    fileprivate var bleManager: CBCentralManager!
    
    /// 要将发现的设备放入数组,否则链接不了
    fileprivate var discoverPeripherals = [CBPeripheral]()
    
    /// 已链接的设备,保存到数组(发送指令的时候要根据不同的设备发送)
    var connectedPeripherals = [CBPeripheral]()
    
    /// 计时器(扫描5秒)
    fileprivate var scanTimer: Timer!
    
    override init() {
        super.init()
        bleManager = CBCentralManager.init(delegate: self, queue: nil)
    }

    // MARK:- CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            switch central.state {
            case CBManagerState.unknown:
                print("CBCentralManager: Unknown")
                
            case CBManagerState.resetting:
                print("CBCentralManager: Resetting")
                
            case CBManagerState.unsupported:
                print("CBCentralManager: Unsupported")
                
            case CBManagerState.unauthorized:
                print("CBCentralManager: Unauthorized")
                
            case CBManagerState.poweredOff:
                print("CBCentralManager: PoweredOff")
                
            case CBManagerState.poweredOn:
                print("CBCentralManager: PoweredOn")
                // PoweredOn之后才能扫描，否则扫描不出设备(好像其他人的实现又不用？)
                // 开始扫描(在这里就可以通过服务的UUID来过滤扫描到的设备)(如果第一参数为nil,则扫描所有设备)
                bleManager.scanForPeripherals(withServices: [kIUL11ServiceUUID], options: nil)
                print("开始扫描5秒")
                scanTimer = Timer.scheduledTimer(timeInterval: scanTime, target: self, selector: #selector(HNCentralManager.shouldConnectDevices), userInfo: nil, repeats: false)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK:发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // kCBAdvDataServiceUUIDs键对应的是一个array(打印中用括号表示的是array，中括号表示的是字典)
        print("发现设备\(peripheral.name); 广播出来的服务有:\(advertisementData["kCBAdvDataServiceUUIDs"])")
        
        // 加入discoverPeripherals数组,待用
        discoverPeripherals.append(peripheral)
    }
    
    // MARK:已链接设备
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // TODO:1、将设备的identifier赋值给light
        
        // 2、发现服务(只需要发现FF12服务即可,因为只有FF12里面有数据写入、读取数据的特征)
        // 要设备peripheral的委托对象(否则不会调用CBPeripheralDelegate中方法)
        peripheral.delegate = self
        peripheral.discoverServices([kIUL11ServiceUUID])
        
        // 3、将已经链接的设备加入connectedPeripherals数组
        connectedPeripherals.append(peripheral)
        print("成功链接\(peripheral.name)，identifier为\(peripheral.identifier)现在有\(connectedPeripherals.count)个链接设备")
    }
    
    // MARK:设备断开链接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        // 将断开链接的设备从connectedPeripherals数组中删除
        if connectedPeripherals.contains(peripheral) {
            connectedPeripherals.remove(at: connectedPeripherals.index(of: peripheral)!)
        }
        print("\(peripheral.name)断开链接，现在有\(connectedPeripherals.count)个链接设备")
    }
    
    // MARK:- CBPeripheralDelegate
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        print("peripheral.RSSI")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("发现设备\(peripheral.services?.count)个服务, 是:\(peripheral.services)")
        // 要做的动作
        // 1、发现特征(IUL11有13个特征,只需要写入数据、读取数据2个特征即可(DataIn、DataOut))
        peripheral.discoverCharacteristics([kCharacteristicDataInUUID, kCharacteristicDataOutUUID], for: peripheral.services![0])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("发现设备\(service.characteristics?.count)个特征, 是:\(service.characteristics)")
        for characteristic in service.characteristics! {
            switch characteristic.uuid {
            case kCharacteristicDataInUUID:
                print("这是用于数据写入的特征,它的UUID是:\(characteristic.uuid)")
                
            case kCharacteristicDataOutUUID:
                // 监听FF02 DataOut特征
                print("这是用于读取数据的特征,它的UUID是:\(characteristic.uuid)")
                peripheral.setNotifyValue(true, for: characteristic)
                
            default:
                print("default")
            }
        }
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("设备的名字被修改了")
        // TODO:设备名更新,更新数据模型;发送通知.(根据设备UUID)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdate_Notification_StateForCharacteristic")
        // TODO:用硬件返回的数据:characteristic的value(0x13指令),更新Light值(数据模型)
    }
    
    // MARK:- 计时结束,链接设备
    func shouldConnectDevices() {
        if discoverPeripherals.count > 0 {
            print("扫描5秒结束,扫描到\(discoverPeripherals.count)个设备,开始链接")
            for peripheral in discoverPeripherals {
                bleManager.connect(peripheral, options: nil)
            }
        }
    }
    
    // MARK:- 指令/数据的发送
    // MARK:指令——同步指令
    func sendSyncCommandToPeriphreal(_ periphreal: CBPeripheral) {
        var cmd: M2DControlSyncRequestCommand!
        cmd.startBit = HNStartBitDA
        cmd.cmd      = HNM2DCommands.hn_COMMAND_SYNC_REQUEST.rawValue
        cmd.content  = 0x00
        cmd.reserved = 0x00
        cmd.checksum = HNChecksumChar88
    }
    
    // MARK:指令——亮度控制指令
    func setupLights(_ lightIdentifiers: [String]!, brightnessValue: UInt8) {
        // 获取要发送指令的所有设备
        let periphreals = self.getPeriphrealsThroughlightIdentifiers(lightIdentifiers)
        
        // 遍历设备，发送指令
        for peripheral in periphreals {
            // 包装指令(数据)
            var cmd = M2DControlBrightnessCommand(startBit: HNStartBitDA, cmd: HNM2DCommands.hn_COMMAND_BRIGHTNESS.rawValue, brightnessValue: brightnessValue, reserved: 0x00, checksum: HNChecksumChar55)
            
            let brightnessData = Data.init(bytes: UnsafePointer<UInt8>(&cmd), count: sizeof(M2DControlBrightnessCommand))
            
            // 获取"数据写入特征"
            let dataInCharacteristic = self.getDataInCharacteristicFormPeriphreal(peripheral)
            
            // 发送数据给硬件
            peripheral.writeValue(brightnessData, for: dataInCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    // MARK:指令——颜色控制指令
    func setupLights(_ lightIdentifiers: [String]!, colorR: UInt8, colorG: UInt8, colorB: UInt8) {
        let periphreals = self.getPeriphrealsThroughlightIdentifiers(lightIdentifiers)
        
        for periphreal in periphreals {
            var cmd: M2DControlColourCommand!
            cmd.startBit = HNStartBitDA
            cmd.cmd = HNM2DCommands.hn_COMMAND_COLOUR.rawValue
            cmd.colourR = colorR
            cmd.colourG = colorG
            cmd.colourB = colorB
            cmd.reserved = 0x00
            cmd.checksum = HNChecksumChar66
            let colorData = Data.init(bytes: UnsafePointer<UInt8>(&cmd), count: sizeof(M2DControlColourCommand))
            
            let dataInCharacteristic = self.getDataInCharacteristicFormPeriphreal(periphreal)
            
            periphreal.writeValue(colorData, for: dataInCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    // MARK:指令——修改硬件名称指令
    func setupNameForLights(_ lightIdentifiers: [String]!) {
        
        // 要用lightIdentifiers数组中的索引获取allLights数组的元素,所以用了两个for循环
        for peripheral in connectedPeripherals {
            for (index, lightIdentifier) in lightIdentifiers.enumerated() {
                if lightIdentifier == peripheral.identifier.uuidString {
                    let nameData: NSMutableData = NSMutableData.init()
                    
                    // 指令头部
                    var cmdHeader: M2DControlSetNameCommandHeader!
                    cmdHeader.startBit = HNStartBitAA
                    nameData.append(&cmdHeader, length: MemoryLayout<M2DControlSetNameCommandHeader>.size)
                    
                    // 指令内容(名字)
                    // 注意和OC的区别
                    let light = HNIUL11Manager.shareManager.store.allLights![index]
                    nameData.append((light.name as NSString).utf8String!, length: light.name.characters.count)
                    
                    // 指令尾部
                    var cmdTail: M2DControlSetNameCommandTail!
                    cmdTail.checksum = HNChecksumChar77
                    nameData.append(&cmdTail, length: MemoryLayout<M2DControlSetNameCommandTail>.size)
                    
                    // 获取"数据写入特征"
                    let dataInCharacteristic = self.getDataInCharacteristicFormPeriphreal(peripheral)
                    
                    peripheral.writeValue(nameData as Data, for: dataInCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                }
            }
        }
    }
    
    // MARK:指令——upload:帮助硬件保存数据指令(传数据到硬件)
    func upload() {
        for (index, peripheral) in connectedPeripherals.enumerated() {
            let light = HNIUL11Manager.shareManager.store.allLights![index]
            
            var cmd: M2DControlHelpSaveCommand!
            cmd.startBit        = HNStartBitDA
            cmd.cmd             = HNM2DCommands.hn_COMMAND_HLPE_SAVE.rawValue
            cmd.colourR         = light.colorR
            cmd.colourG         = light.colorG
            cmd.colourB         = light.colorB
            cmd.brightnessValue = light.brightness
            cmd.reserved        = 0x00
            cmd.checksum        = HNChecksumChar9A
            
            let dataInCharacteristic = self.getDataInCharacteristicFormPeriphreal(peripheral)
            
            // 断行也没有像OC那么直观(OC是以冒号对齐的，可读性强)
            peripheral.writeValue(Data.init(bytes: UnsafePointer<UInt8>(&cmd),
                count: sizeof(M2DControlHelpSaveCommand)),
                for: dataInCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    // MARK:指令——erase:帮助硬件恢复初始值
    func erase() {
        for peripheral in connectedPeripherals {
            var cmd: M2DControlHelpSaveCommand!
            cmd.startBit        = HNStartBitDA
            cmd.cmd             = HNM2DCommands.hn_COMMAND_HLPE_SAVE.rawValue
            cmd.colourR         = 255
            cmd.colourG         = 255
            cmd.colourB         = 255
            cmd.brightnessValue = 255
            cmd.reserved        = 0x00
            cmd.checksum        = HNChecksumChar9A
            
            let dataInCharacteristic = self.getDataInCharacteristicFormPeriphreal(peripheral)
            
            // 断行也没有像OC那么直观(OC是以冒号对齐的，可读性强)
            peripheral.writeValue(Data.init(bytes: UnsafePointer<UInt8>(&cmd),
                count: sizeof(M2DControlHelpSaveCommand)),
                for: dataInCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    // MARK:获取需要发送指令的设备的Help Method
    func getPeriphrealsThroughlightIdentifiers(_ lightIdentifiers: [String]!) -> [CBPeripheral] {
        var periphreals = [CBPeripheral]()
        for peripheral in connectedPeripherals {
            for lightIdentifier in lightIdentifiers {
                if lightIdentifier == peripheral.identifier.uuidString {
                    periphreals.append(peripheral)
                }
            }
        }
        return periphreals
    }
    
    // MARK:获取对应设备"数据写入特征"的Help Method
    func getDataInCharacteristicFormPeriphreal(_ periphreal: CBPeripheral) -> CBCharacteristic {
        var dataInCharacteristic: CBCharacteristic!
        for service in periphreal.services! {
            if service.uuid == kIUL11ServiceUUID {
                for characteristic in service.characteristics! {
                    if characteristic.uuid == kCharacteristicDataInUUID {
                        dataInCharacteristic = characteristic
                    }
                }
            }
        }
        return dataInCharacteristic
    }

}
