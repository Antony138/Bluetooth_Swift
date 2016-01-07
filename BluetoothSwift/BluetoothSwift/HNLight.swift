//
//  HNLight.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/7/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNLight: NSObject, NSCoding {
    var identifier: String
    var brightness: Int32
    var colorR: Int32
    var colorG: Int32
    var colorB: Int32
    var name: String
    var isSelected: Bool
    var isGrouped: Bool
    var groupIndex: Int32
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
    
    required init?(coder aDecoder: NSCoder) {
        identifier  = aDecoder.decodeObjectForKey("identifier") as! String
        brightness  = aDecoder.decodeIntForKey("brightness")
        colorR      = aDecoder.decodeIntForKey("colorR")
        colorG      = aDecoder.decodeIntForKey("colorG")
        colorB      = aDecoder.decodeIntForKey("colorB")
        name        = aDecoder.decodeObjectForKey("name") as! String
        groupIndex  = aDecoder.decodeIntForKey("groupIndex")
        isSelected  = aDecoder.decodeBoolForKey("isSelected")
        isGrouped   = aDecoder.decodeBoolForKey("isGrouped")
        isOn        = aDecoder.decodeBoolForKey("isOn")
        isConnected = aDecoder.decodeBoolForKey("isConnected")
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeInt(Int32(brightness), forKey: "brightness")
        aCoder.encodeInt(Int32(colorR), forKey: "colorR")
        aCoder.encodeInt(Int32(colorG), forKey: "colorG")
        aCoder.encodeInt(Int32(colorB), forKey: "colorB")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInt(Int32(groupIndex), forKey: "groupIndex")
        aCoder.encodeBool(isSelected, forKey: "isSelected")
        aCoder.encodeBool(isGrouped, forKey: "isGrouped")
        aCoder.encodeBool(isOn, forKey: "isOn")
        aCoder.encodeBool(isConnected, forKey: "isConnected")
    }
}
