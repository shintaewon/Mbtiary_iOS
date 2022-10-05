//
//  ViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/05.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 50)
        
        for fontFamily in UIFont.familyNames {
                    for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                        print(fontName)
                    }
                }
        
        loginBtn.layer.cornerRadius = loginBtn.layer.frame.height/2
        loginBtn.layer.shadowColor = UIColor.black.cgColor // 색깔
        loginBtn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        loginBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        loginBtn.layer.shadowRadius = 5 // 반경
        loginBtn.layer.shadowOpacity = 0.3 // alpha값
    }

    
}

