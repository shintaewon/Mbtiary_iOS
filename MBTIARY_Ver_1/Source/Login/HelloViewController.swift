//
//  HelloViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/08.
//

import UIKit

class HelloViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var askingLabel: UILabel!
    
    @IBOutlet weak var testBtn: UIButton!
    
    var name : String = ""
    var greeting = "이제 거의 다 되어가요."
    var asking = "MBTIARY를 이용할 준비가 되셨나요?"
    
    @IBOutlet weak var noTutorialBtn: UIButton!
    
    
    @IBAction func didTapNoTutorialBtn(_ sender: Any) {
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testBtn.isHidden = true
        
        nameLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 30)
        
        greetingLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 30)
        
        askingLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 30)
        
        testBtn.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputAnimation()
    }
    func inputAnimation(){
        
        let str = name + "님! 만나서 반갑습니다."
        
        for i in str {
            nameLabel.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
        
        for i in greeting {
            greetingLabel.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
        
        for i in asking {
            askingLabel.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
        
        testBtn.isHidden = false
    }
    
}
