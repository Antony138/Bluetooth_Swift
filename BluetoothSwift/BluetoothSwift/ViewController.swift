//
//  ViewController.swift
//  BluetoothSwift
//
//  Created by YuHeng_Antony on 1/5/16.
//  Copyright © 2016 Homni Electron Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        HNIUL11Manager.shareManager
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

