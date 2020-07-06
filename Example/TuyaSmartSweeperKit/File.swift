//
//  File.swift
//  TuyaSmartSweeperKit_Example
//
//  Created by Misaka on 2020/7/6.
//  Copyright © 2020 misakatao. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    
    var sweeperDevice : TuyaSmartSweeperDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sweeperDevice = TuyaSmartSweeperDevice.init(deviceId: "")
        sweeperDevice?.getFileDownloadInfo(withLimit: 50, offset: 0, success: { (list, count) in
            
        }, failure: { (error) in
            
        })
    }
}
