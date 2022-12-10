//
//  WithdrawViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/12/08.
//

import UIKit
import Alamofire

class WithdrawViewController: UIViewController {

    @IBOutlet weak var goBackBtn: UIButton!
    
    @IBOutlet weak var withdrawBtn: UIButton!
    
    @IBOutlet weak var explainLabel_1: UILabel!
    
    @IBOutlet weak var explainLabel_2: UILabel!
    
    @IBAction func didTapWithdrawBtn(_ sender: Any) {
        self.present(alertConfirm, animated: true, completion: nil)
    }
    
    @IBAction func didTapGoBackBtn(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    let str_1 = "정말 떠나시는 건가요?"
    
    let str_2 = "한 번 더 생각해 보지 않으시겠어요?"
    
    let alertConfirm = UIAlertController(title: "잠깐!", message: "정말 탈퇴를 하시겠어요?\n 탈퇴 이후 30일동안 재가입이 불가능해요!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goBackBtn.isHidden = true
        withdrawBtn.isHidden = true
        
        goBackBtn.layer.cornerRadius = 6
        withdrawBtn.layer.cornerRadius = 6
        
        let str_1 = "정말 떠나시는 건가요?"
        
        let str_2 = "한 번 더 생각해 보지 않으시겠어요?"
        
        alertConfirm.addAction(UIAlertAction(title: "취소", style: .default) { action in
            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        })
        
        alertConfirm.addAction(UIAlertAction(title: "탈퇴할게요", style: .default) { action in
            self.withdrawUser()
            
        })
    }
    

    override func viewDidAppear(_ animated: Bool) {
        inputAnimation()
    }
    
    func inputAnimation(){
        
        for i in str_1 {
            explainLabel_1.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
        
        for i in str_2 {
            explainLabel_2.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
        
        goBackBtn.isHidden = false
        withdrawBtn.isHidden = false
    }

}

extension WithdrawViewController{
    
    func withdrawUser(){
        let url = "\(Constant.BASE_URL)/users/\(Constant.userIndex)/status"
        
        AF.request(url, method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: DeleteDiaryResponse.self){
            response in
            
            switch response.result {
                
            case .success(let response):
                print("Success>> NickName \(response) ")
            
                
                
            case .failure(let error):
                print("DEBUG>> NickName Error : \(error.localizedDescription)")
                
                
            }
        }
    }
}
