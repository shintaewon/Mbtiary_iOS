//
//  ViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/05.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTemplate
import Alamofire

class ViewController: UIViewController {
    
    var accessToken : String = ""
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    //var autoLoginResponse : AutoLoginResponse = AutoLoginResponse(isSuccess: false, code: 0, message: " ")
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    self.accessToken = oauthToken?.accessToken ?? " "
                    print("토큰:")
                    print(self.accessToken)
                    //번장 홈 화면으로 넘어감
                    self.postToken()
                
                    
                    
                }
            }
        
    }
    
    func postToken(){
        let url = "\(Constant.BASE_URL)/auth/login/kakao"
        
        let _ : HTTPHeaders = [
                    "Content-Type" : "application/json"
                ]
        
        let bodyData : Parameters = [
            "access_token" : "\(accessToken)"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: bodyData,
                   encoding: JSONEncoding.default,
                   headers: nil).responseDecodable(of: LoginResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("DEBUG>> Login Response \(response) ")
                    Constant.JWT = response.result.jwt
                    Constant.userIndex = response.result.userIdx
                    Constant.nickName = response.result.nickname
                    
                    UserDefaults.standard.set(response.result.userIdx, forKey: "userIndex")
                    self.setUserInfo()
                    
                    UserDefaults.standard.set(response.result.jwt, forKey: "JWT")
                    
                    UserDefaults.standard.set(false, forKey: "isFirstLaunch")
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else{
                        return
                    }
                    
                    vc.modalPresentationStyle = .fullScreen
                    
                    vc.modalTransitionStyle = .coverVertical
                    
                    self.present(vc, animated: true)
                    
                    
                case .failure(let error):
                    print("DEBUG>> Login Post Error : \(error.localizedDescription)")
                    
                    
                    
                    }
                }
            }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                UserDefaults.standard.set(user?.kakaoAccount?.profile?.nickname, forKey: "NickName")
                
                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                    let data = try? Data(contentsOf: url) {
                    
                    guard let pic = UIImage(data: data)?.jpegData(compressionQuality: 0.5) else { return }
                        let encoded = try! PropertyListEncoder().encode(pic)
                        UserDefaults.standard.set(encoded, forKey: "profileImage")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 50)
        
        loginBtn.layer.cornerRadius = loginBtn.layer.frame.height/2
        loginBtn.layer.shadowColor = UIColor.black.cgColor // 색깔
        loginBtn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        loginBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        loginBtn.layer.shadowRadius = 5 // 반경
        loginBtn.layer.shadowOpacity = 0.3 // alpha값
        print("된건가.?")
    }

    
}


