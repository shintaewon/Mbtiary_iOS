//
//  NewDiaryViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/31.
//

import UIKit
import Alamofire

class NewDiaryViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var textViewField: UITextView!
    
    @IBOutlet weak var textCountLabel: UILabel!
   
    var ableToPostFlag : Bool = false // 글자수가 적당해야 True
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var pickedImg: UIImageView!
    
    @IBOutlet weak var opentToPublicLabel: UILabel!
    
    var NewDiaryPostResponse : NewDiaryResponse = NewDiaryResponse(isSuccess: true, code: 0, message: "", result: DiaryIndex(diaryIdx: 0))
    
    var selectedImage : UIImage = UIImage()

    let alertOpen = UIAlertController(title: "잠깐!", message: "다이어리 작성을 완료하시겠어요?\n 이 일기는 다른 사람들이 볼 수 있어요!", preferredStyle: .alert)
    
    let alertNotOpen = UIAlertController(title: "잠깐!", message: "다이어리 작성을 완료하시겠어요?\n 이 일기는 다른 사람들이 볼 수 없어요!", preferredStyle: .alert)
    var isSecretToPublic : String = ""
    var isOpenToPublic : Bool = true
    
    @IBAction func isOpenToPublic(_ sender: UISwitch) {
        if sender.isOn {
            isOpenToPublic = true
            opentToPublicLabel.text = "사람들이 내 일기를 볼 수 있어요!"
        }
        else{
            isOpenToPublic = false
            opentToPublicLabel.text = "사람들이 내 일기를 볼 수 없어요!"
        }
        
        print(isOpenToPublic)
    }
    
    @IBAction func didTapGoBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapCompleteBtn(_ sender: Any) {
        if isOpenToPublic == true{
            self.present(alertOpen, animated: true, completion: nil)
        }
        else{
            self.present(alertNotOpen, animated: true, completion: nil)
        }
        
        //postDiary()
        
        
    }

    @IBAction func didTapGalleryBtn(_ sender: Any) {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappedAround()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let current_date_string = formatter.string(from: Date())
        
        print(current_date_string)
        
        dateLabel.text = current_date_string
        //dateLabel.font = UIFont(name: "NanumGangBuJangNimCe", size: 25)
        
        /*backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        backgroundView.layer.cornerRadius = 15*/
        
        completeBtn.layer.cornerRadius = 10
        
        textViewField.delegate = self
        textViewField.text = """
         일기를 작성해주세요. (공백포함 최소 200자 최대 1000자)
        
         정확한 MBTI 분석을 위해 온전한 단어로 구성된 문장을 작성해주세요.
        
         표준어로 작성할수록 분석결과가 높아진답니다!
        """
        textViewField.textColor = UIColor.gray
        textViewField.font = UIFont(name: "NanumGangBuJangNimCe", size: 20)
        
        textCountLabel.text = "0"
        
        textViewField.layer.cornerRadius = 15
        
        pickedImg.image = UIImage(named: "갤러리.png")
        
        alertOpen.addAction(UIAlertAction(title: "취소", style: .default) { action in
          //취소처리...
        })
        
        alertOpen.addAction(UIAlertAction(title: "확인했어요", style: .default) { action in
            print("post!")
            self.postDiary()
        })
        
        alertNotOpen.addAction(UIAlertAction(title: "취소", style: .default) { action in
          //취소처리...
        })
        
        alertNotOpen.addAction(UIAlertAction(title: "확인했어요", style: .default) { action in
            print("post!")
            self.postDiary()
        })
        
        
    }
    
}


extension NewDiaryViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.gray {
        textView.text = nil
        textView.textColor = UIColor.black
      }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
        textView.text = """
         일기를 작성해주세요. (공백포함 최소 500자 최대 2000자)
        
         정확한 분석을 위해 온전한 단어로 구성된 문장을 작성해주세요.
        
         표준어로 작성할수록 분석결과의 정확도가 높아진답니다!
        """
        textView.textColor = UIColor.gray
      }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textViewField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false}
        
        let changeText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCountLabel.text = "\(changeText.count)"
        
        if changeText.count < 200 {
            textCountLabel.textColor = UIColor.red
            ableToPostFlag = false
        }
        else{
            textCountLabel.textColor = UIColor.darkGray
            ableToPostFlag = true
        }
        return changeText.count < 1501
    }
}

extension NewDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                pickedImg.image = image
                selectedImage = image
            }
            
            picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}


extension NewDiaryViewController{
    
    func postDiary(){
        let url = "\(Constant.BASE_URL)/diarys"
        
        
        if isOpenToPublic == true{
            isSecretToPublic = "F"
        }
        else{
            isSecretToPublic = "T"
        }
        
        let parameter : [String : Any] = [
            "contents" : "\(textViewField.text ?? " ")",
            "isSecret" : "\(isSecretToPublic)"
        ]
        
        let resizedImage = resizeImage(image: selectedImage, newWidth: 300)
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        
        AF.upload(
            multipartFormData: {multipartFormData in
                
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
                if((imageData) != nil){
                    
                    multipartFormData.append(imageData!, withName: "diaryImg", fileName: "diaryPic.jpeg", mimeType: "image/jpeg")
                }
            }, to: "\(url)", usingThreshold: UInt64.init(), method: .post, headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of :NewDiaryResponse.self) {
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> New Diary \(response) ")
                    
                    self.NewDiaryPostResponse = response
                    
                    
                    self.sendToML(diaryIndex: self.NewDiaryPostResponse.result.diaryIdx)
                    
                    
                    
                case .failure(let error):
                    print("DEBUG>> New Diary Error : \(error.localizedDescription)")
                    
                }
            }
    }
        
        /*AF.request(url,
                   method: .post,
                   parameters: bodyData,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: NewDiaryResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> New Diary \(response) ")
                    
                    self.NewDiaryPostResponse = response
                    
                    self.sendToML(diaryIndex: self.NewDiaryPostResponse.result.diaryIdx)
                    
                    
                    
                case .failure(let error):
                    print("DEBUG>> New Diary Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
            }*/
    
    func sendToML(diaryIndex : Int ){
        
        let url = "\(Constant.BASE_URL)/diarys/\(NewDiaryPostResponse.result.diaryIdx)/mbti"
        print(url)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: NewDiaryPostMlResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> New Mbti \(response) ")
                    
                    self.dismiss(animated: true)
                    
                    
                case .failure(let error):
                    print("DEBUG>> New Mbti Error : \(error.localizedDescription)")
          
                }
                }
    }
}
