//
//  MyPageViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/28.
//

import UIKit
import Alamofire
import Kingfisher

class MyPageViewController: UIViewController {

    @IBOutlet weak var extraView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func didTapGoBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapEditUserInfoBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditUserInfoViewController") as? EditUserInfoViewController else { return }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCalendarContents()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        extraView.addGestureRecognizer(tapGesture)
        nameLabel.text = (UserDefaults.standard.string(forKey: "nickName") ?? "") + "의 일기"
    }
    
}

extension MyPageViewController{
    
    func getCalendarContents(){
        
        let url = "\(Constant.BASE_URL)/users/\(Constant.userIndex)"
        
        print(url)
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: UserInfoResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> getCalendarContents \(response) ")
                    
                    if response.result.profileImgURL == "F" {
                        guard let data = UserDefaults.standard.data(forKey: "profileImage") else { return }
                        
                        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
                        let image = UIImage(data: decoded)
                        
                        self.profileImage.image = image
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
                    }
                    else{
                        
                        let url = URL(string: response.result.profileImgURL)
                        
                        let processor = RoundCornerImageProcessor(cornerRadius: self.profileImage.frame.height/2)
                        self.profileImage.kf.setImage(with: url, options: [.processor(processor)])
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
                    }
                    
                case .failure(let error):
                    print("DEBUG>> getCalendarContents Error : \(error.localizedDescription)")
                
                    
                }
            }
    }
    
}
