//
//  HNHomeViewController.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/7/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class HNHomeViewController: UIViewController, HNCustomLightButtonDelegate, SwiftHSVColorPickerDelegate {

    
    /// 色盘
    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!
    
    /// 8个灯按钮
    @IBOutlet var lightButtonViews: [UIView]!
    
    /// 灯开关按钮
    @IBOutlet weak var lightToggleButton: UIButton!
    
    /// 切换到编辑页面按钮
    @IBOutlet weak var editPageToggleButton: UIButton!
    
    /// 群组编辑按钮
    @IBOutlet var groupButtons: [UIButton]!
    
    /// 亮度调节slider
    @IBOutlet weak var brightnessSlider: UISlider!
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK:- HNCustomLightButtonDelegate
    func click(view: HNCustomLightButton, tag: Int) {
        print("调用了HNCustomLightButtonDelegate中的方法")
    }
    
    // MARK:- SwiftHSVColorPickerDelegate
    func touchColorWheel(view: SwiftHSVColorPicker, color: UIColor, brightness: CGFloat, colorR: CGFloat, colorG: CGFloat, colorB: CGFloat) {
        print("调用SwiftHSVColorPickerDelegate")
    }
    
}
