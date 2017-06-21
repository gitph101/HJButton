//
//  ViewController.swift
//  HJButton
//
//  Created by 研究院01 on 15/3/31.
//  Copyright (c) 2015年 HJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var btn : HJButton = HJButton(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
//        btn.backgroundColor  = UIColor.redColor()
        btn.buttonType = HJButton.HJFlashButtonType.hjFlashButtonTypeInner
        view.addSubview(btn)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

