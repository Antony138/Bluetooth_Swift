//
//  HNBaseCommand.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/6/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import Foundation

// MARK:- 常量
let HNStartBitDA: UInt8     = 0xDA
let HNStartBitAA: UInt8     = 0xAA
let HNChecksumChar55: UInt8 = 0x55
let HNChecksumChar66: UInt8 = 0x66
let HNChecksumChar77: UInt8 = 0x77
let HNChecksumChar88: UInt8 = 0x88
let HNChecksumChar99: UInt8 = 0x99
let HNChecksumChar9A: UInt8 = 0x9A

// MARK:- DEVICE COMMAND CODE
// MOBILE2DEVICE
enum HNM2DCommands: Int8 {
    /// 亮度控制指令
   case HN_COMMAND_BRIGHTNESS   = 0x10
    /// 颜色控制指令
   case HN_COMMAND_COLOUR       = 0x11
    /// 请求(同步)数据指令
   case HN_COMMAND_SYNC_REQUEST = 0x12
    /// 发送亮度&颜色给硬件,协助硬件保存数据
   case HN_COMMAND_HLPE_SAVE    = 0x14
    /// 设置模块名称指令(这条指令没有指定指令号,只有起始位)
   case HN_COMMAND_SET_NAME     = 0x00
}

// DEVICE2MOBILE
enum HND2MResponses: Int8 {
    case HN_FEEDBACK_DATA = 0x13
}

// MARK:- Mobile 2 Device
// MARK:Command: 0x10 亮度控制指令
struct M2DControlBrightnessCommand {
    var startBit: UInt8
    var cmd: UInt8
    var brightnessValue: UInt8
    var reserved: UInt8
    var checksum: UInt8// 0x55
}

// MARK:Command: 0x11 颜色控制指令
struct M2DControlColourCommand {
    var startBit: UInt8
    var cmd: UInt8
    var colourR: UInt8
    var colourG: UInt8
    var colourB: UInt8
    var reserved: UInt8
    var checksum: UInt8// 0x66
}

// MARK:Command: 0x12 请求(同步)数据指令
struct M2DControlSyncRequestCommand {
    var startBit: UInt8
    var cmd: UInt8
    var content: UInt8// 0x00
    var reserved: UInt8
    var checksum: UInt8// 0x88
}

// MARK:Command: Command: 0x14 发送亮度&颜色给硬件,协助硬件保存数据
struct M2DControlHelpSaveCommand {
    var startBit: UInt8
    var cmd: UInt8
    var colourR: UInt8
    var colourG: UInt8
    var colourB: UInt8
    var brightnessValue: UInt8
    var reserved: UInt8
    var checksum: UInt8// 0x9A
}

// MARK:Command: 设置蓝牙模块名称指令
struct M2DControlSetNameCommandHeader {
    var startBit: UInt8
}

struct M2DControlSetNameCommandTail {
    var checksum: UInt8// 0x77
}

// MARK:- Device 2 Mobile
// MARK:Response: 0x13 模块返回数据
struct D2MDeviceParamResponse {
    var startBit: UInt8
    var cmd: UInt8
    var colourR: UInt8
    var colourG: UInt8
    var colourB: UInt8
    var brightnessValue: UInt8
    var reserved: UInt8
    var checksum: UInt8
}