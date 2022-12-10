//
//  SplashScreenViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/25.
//

import UIKit
import Alamofire

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.checkAutoLogin(jwt: UserDefaults.standard.string(forKey: "JWT") ?? " ")
            
        }
    }

}


extension SplashScreenViewController{
    
    func checkAutoLogin(jwt : String){
        
        let url = "\(Constant.BASE_URL)/auth/auto-login"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(jwt)"]).responseDecodable(of: AutoLoginResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> AutoLogin \(response) ")
                    
                    if response.code == 1001    {
                        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                    else{
                        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else{
                            return
                        }
                        
                        mainVC.modalPresentationStyle = .fullScreen
                        
                        self.present(mainVC, animated: false, completion: nil)
                    }
                case .failure(let error):
                    print("DEBUG>> AutoLogin Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
    }
}
