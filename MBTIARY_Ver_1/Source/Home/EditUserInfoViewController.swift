//
//  EditUserInfoViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/12/08.
//

import UIKit
import Alamofire
import Kingfisher

class EditUserInfoViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    var profileImgtoUpdate : UIImage = UIImage()
    
    let imagePickerController = UIImagePickerController()
    
    
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBAction func didTapEditProfilePicBtn(_ sender: Any) {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func didTapGoBackBtn(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    @IBAction func didTapEditBtn(_ sender: Any) {
        patchNickName(userNickName: nameTxtField.text ?? "")
    }
    
    
    @IBAction func didTapWithdrawBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawViewController") as? WithdrawViewController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
        editBtn.layer.cornerRadius = 10
        nameTxtField.placeholder = UserDefaults.standard.string(forKey: "nickName")
        
        dismissKeyboardWhenTappedAround()
    }

}

extension EditUserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profileImg.image = image
                postProfileImg()
            }
            
            picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}

extension EditUserInfoViewController{
    
    func getUserInfo(){
        
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
                    print("Success>> getUserInfo \(response) ")
                    
                    if response.result.profileImgURL == "F" {
                        guard let data = UserDefaults.standard.data(forKey: "profileImage") else { return }
                        
                        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
                        let image = UIImage(data: decoded)
                        
                        self.profileImg.image = image
                        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
                    }
                    else{
                        
                        let url = URL(string: response.result.profileImgURL)
                        
                        let processor = RoundCornerImageProcessor(cornerRadius: self.profileImg.frame.height/2)
                        self.profileImg.kf.setImage(with: url, options: [.processor(processor)])
                        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
                    }
                    
                case .failure(let error):
                    print("DEBUG>> getUserInfo Error : \(error.localizedDescription)")
                
                    
                }
            }
    }
    
    func postProfileImg(){
        
        let url = "\(Constant.BASE_URL)/users/\(Constant.userIndex)/profile-img-url"
        
        let resizedImage = resizeImage(image: profileImg.image ?? UIImage(), newWidth: 300)
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        
        AF.upload(
            multipartFormData: {multipartFormData in
                
                if((imageData) != nil){
                    
                    multipartFormData.append(imageData!, withName: "profileImg", fileName: "profileImg.jpeg", mimeType: "image/jpeg")
                }
            }, to: "\(url)", usingThreshold: UInt64.init(), method: .patch, headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of :DeleteDiaryResponse.self) {
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> postProfileImg \(response) ")
                    
                case .failure(let error):
                    print("DEBUG>> postProfileImg Error : \(error.localizedDescription)")
                    
                }
            }
    }
    
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
                    UserDefaults.standard.set(Constant.nickName, forKey: "nickName")
                    
                    UserDefaults.standard.set(self.nameTxtField.text, forKey: "nickName")
                    
                    Constant.nickName = self.nameTxtField.text ?? " "
                    
                    self.nameTxtField.text = ""
                    self.nameTxtField.placeholder = Constant.nickName
                    
                    self.presentBottomAlert(message: "수정이 완료되었습니다!")
                }
                
                
            case .failure(let error):
                print("DEBUG>> NickName Error : \(error.localizedDescription)")
                
                
            }
        }
    }
}


