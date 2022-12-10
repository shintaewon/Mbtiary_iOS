//
//  MainTabBarViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        // Do any additional setup after loading the view.
    }
    
    

}
