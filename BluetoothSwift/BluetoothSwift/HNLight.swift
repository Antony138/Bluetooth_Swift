//
//  HNLight.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/7/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNLight: NSObject, NSCoding {
    
    // MARK: Types
    struct PropertyKey {
        static let identifierKey  = "identifier"
        static let brightnessKey  = "brightness"
        static let colorRKey      = "colorR"
        static let colorGKey      = "colorG"
        static let colorBKey      = "colorB"
        static let nameKey        = "name"
        static let isSelectedKey  = "isSelected"
        static let isGroupedKey   = "isGrouped"
        static let groupIndexKey  = "groupIndex"
        static let isOnKey        = "isOn"
        static let isConnectedKey = "isConnected"
    }
    
    // MARK: Properties
    var identifier: String
    var brightness: UInt8
    var colorR: UInt8
    var colorG: UInt8
    var colorB: UInt8
    var name: String
    var isSelected: Bool
    var isGrouped: Bool
    var groupIndex: Int
    var isOn: Bool
    var isConnected: Bool

    override init() {
        identifier  = kDefaultIdentifier
        brightness  = kDefaultBrightness
        colorR      = kDefaultColorR
        colorG      = kDefaultColorG
        colorB      = kDefaultColorB
        name        = kDefaultLightName
        groupIndex  = kDefaultGroupIndex
        isSelected  = false
        isGrouped   = false
        isOn        = false
        isConnected = false
    }
    
    // MARK: NSCoding
    // 编码/固化
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: PropertyKey.identifierKey)
        aCoder.encodeBytes(&brightness, length: MemoryLayout<UInt8>.size, forKey: PropertyKey.brightnessKey)
        aCoder.encodeBytes(&colorR, length: MemoryLayout<UInt8>.size, forKey: PropertyKey.colorRKey)
        aCoder.encodeBytes(&colorG, length: MemoryLayout<UInt8>.size, forKey: PropertyKey.colorGKey)
        aCoder.encodeBytes(&colorB, length: MemoryLayout<UInt8>.size, forKey: PropertyKey.colorBKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encodeCInt(Int32(groupIndex), forKey: PropertyKey.groupIndexKey)
        aCoder.encode(isSelected, forKey: PropertyKey.isSelectedKey)
        aCoder.encode(isGrouped, forKey: PropertyKey.isGroupedKey)
        aCoder.encode(isOn, forKey: PropertyKey.isOnKey)
        aCoder.encode(isConnected, forKey: PropertyKey.isConnectedKey)
    }
    
    // 解码/解固
    // required表示子类都必须实现这个初始化方法？
    // convenience关键字
    // 问号(?)表示这个初始化方法(failable initializer)有可能返回nil
    required init?(coder aDecoder: NSCoder) {
         // decodeObjectForKey(_:)方法的返回值是AnyObject,所以先要进行类型强转
        // (as!)是forced type cast operator,也就是类型强转(区别(as?)是optional type cast operator)
        var length  = MemoryLayout<UInt8>.size
        identifier  = aDecoder.decodeObject(forKey: PropertyKey.identifierKey) as! String
        brightness  = (aDecoder.decodeBytes(forKey: PropertyKey.brightnessKey, returnedLength: &length)?.pointee)!
        colorR      = (aDecoder.decodeBytes(forKey: PropertyKey.colorRKey, returnedLength: &length)?.pointee)!
        colorG      = (aDecoder.decodeBytes(forKey: PropertyKey.colorGKey, returnedLength: &length)?.pointee)!
        colorB      = (aDecoder.decodeBytes(forKey: PropertyKey.colorBKey, returnedLength: &length)?.pointee)!
        name        = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        groupIndex  = aDecoder.decodeInteger(forKey: PropertyKey.groupIndexKey)
        isSelected  = aDecoder.decodeBool(forKey: PropertyKey.isSelectedKey)
        isGrouped   = aDecoder.decodeBool(forKey: PropertyKey.isGroupedKey)
        isOn        = aDecoder.decodeBool(forKey: PropertyKey.isOnKey)
        isConnected = aDecoder.decodeBool(forKey: PropertyKey.isConnectedKey)
    }
}
