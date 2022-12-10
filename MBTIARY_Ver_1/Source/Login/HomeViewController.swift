//
//  HomeViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/08.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var exlpainLabel: UILabel!
    
    
    @IBOutlet weak var nameTxtField: UITextField!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var str = "당신의 이름을 입력해주세요."
   
    @IBAction func didTapNextBtn(_ sender: Any) {
        
        if nameTxtField.text?.count ?? 0 < 3 {
            self.presentBottomAlert(message: "최소 3글자이상 입력해주세요.")
        }
        else if nameTxtField.text?.count ?? 0 > 5 {
            self.presentBottomAlert(message: "최대 5글자까지 입력할 수 있습니다")
        }
        else{
            patchNickName(userNickName: nameTxtField.text ?? " ")
            
        }
        
        
        //vc.nameLabel.text = (nameTxtField.text ?? "") + "님!"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        exlpainLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 30)
        
        nextBtn.layer.cornerRadius = 10
        
    }
    override func viewDidAppear(_ animated: Bool) {
        inputAnimation()
    }
    
    func inputAnimation(){
        
        for i in str {
            exlpainLabel.text! += "\(i)"
            
            RunLoop.current.run(until: Date() + 0.10)
        }
    }

}


extension HomeViewController {
    
    func patchNickName(userNickName : String){
        let url = "\(Constant.BASE_URL)/users/\(Constant.userIndex)/nickname"
        
        let bodyData : Parameters = [
            "nickName" : "\(userNickName)"
            
        ]
        
        AF.request(url, method: .patch, parameters: bodyData, encoding: JSONEncoding.default, headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: NickNameResponse.self){
            response in
            
            switch response.result {
                
            case .success(let response):
                print("Success>> NickName \(response) ")
                
                if response.code == 3101 {
                    self.presentBottomAlert(message: "중복된 닉네임입니다.")
                }
                else if response.code == 1000{
                    UserDefaults.standard.set(self.nameTxtField.text, forKey: "nickName")
                    
                    Constant.nickName = self.nameTxtField.text ?? " "
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelloViewController") as? HelloViewController else{
                        return
                    }
                    
                    vc.modalPresentationStyle = .fullScreen
                    
                    vc.modalTransitionStyle = .coverVertical
                    
                    vc.name = self.nameTxtField.text ?? ""
                    
                    self.present(vc, animated: true)
                }
                
                
            case .failure(let error):
                print("DEBUG>> NickName Error : \(error.localizedDescription)")
                
                
            }
        }
    }
        
    
}
