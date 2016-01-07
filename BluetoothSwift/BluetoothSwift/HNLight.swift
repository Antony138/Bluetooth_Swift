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
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: PropertyKey.identifierKey)
        aCoder.encodeBytes(&brightness, length: sizeof(UInt8), forKey: PropertyKey.brightnessKey)
        aCoder.encodeBytes(&colorR, length: sizeof(UInt8), forKey: PropertyKey.colorRKey)
        aCoder.encodeBytes(&colorG, length: sizeof(UInt8), forKey: PropertyKey.colorGKey)
        aCoder.encodeBytes(&colorB, length: sizeof(UInt8), forKey: PropertyKey.colorBKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeInt(Int32(groupIndex), forKey: PropertyKey.groupIndexKey)
        aCoder.encodeBool(isSelected, forKey: PropertyKey.isSelectedKey)
        aCoder.encodeBool(isGrouped, forKey: PropertyKey.isGroupedKey)
        aCoder.encodeBool(isOn, forKey: PropertyKey.isOnKey)
        aCoder.encodeBool(isConnected, forKey: PropertyKey.isConnectedKey)
    }
    
    // 解码/解固
    // required表示子类都必须实现这个初始化方法？
    // convenience关键字
    // 问号(?)表示这个初始化方法(failable initializer)有可能返回nil
    required init?(coder aDecoder: NSCoder) {
         // decodeObjectForKey(_:)方法的返回值是AnyObject,所以先要进行类型强转
        // (as!)是forced type cast operator,也就是类型强转(区别(as?)是optional type cast operator)
        var length  = sizeof(UInt8)
        identifier  = aDecoder.decodeObjectForKey(PropertyKey.identifierKey) as! String
        brightness  = aDecoder.decodeBytesForKey(PropertyKey.brightnessKey, returnedLength: &length).memory
        colorR      = aDecoder.decodeBytesForKey(PropertyKey.colorRKey, returnedLength: &length).memory
        colorG      = aDecoder.decodeBytesForKey(PropertyKey.colorGKey, returnedLength: &length).memory
        colorB      = aDecoder.decodeBytesForKey(PropertyKey.colorBKey, returnedLength: &length).memory
        name        = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        groupIndex  = aDecoder.decodeIntegerForKey(PropertyKey.groupIndexKey)
        isSelected  = aDecoder.decodeBoolForKey(PropertyKey.isSelectedKey)
        isGrouped   = aDecoder.decodeBoolForKey(PropertyKey.isGroupedKey)
        isOn        = aDecoder.decodeBoolForKey(PropertyKey.isOnKey)
        isConnected = aDecoder.decodeBoolForKey(PropertyKey.isConnectedKey)
    }
}
