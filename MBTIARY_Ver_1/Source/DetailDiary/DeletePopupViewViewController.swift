//
//  DeletePopupViewViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/12/07.
//

import UIKit
import Alamofire

protocol DeletePopupViewViewControllerDelegate : AnyObject {
    func addDeleteDates(date : Date)
}

class DeletePopupViewViewController: UIViewController {

    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var upperView: UIView!
    
    weak var DeleteDiaryDelegate : DeletePopupViewViewController?
    
    var diaryIndex : Int = 0
    var createdAt : Date = Date()
    
    let alertConfirm = UIAlertController(title: "잠깐!", message: "다이어리를 정말 삭제하시겠어요?\n 한번 삭제된 다이어리는 복구할 수 없어요!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("diaryIndex: ", diaryIndex)
        deleteBtn.layer.cornerRadius = 8
        backGroundView.layer.cornerRadius = 16
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        upperView.addGestureRecognizer(tapGesture)
        
        alertConfirm.addAction(UIAlertAction(title: "취소", style: .default) { action in
          //취소처리...
        })
        
        alertConfirm.addAction(UIAlertAction(title: "확인했어요", style: .default) { action in
            print("post!")
            self.deleteDiary()
        })
        
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
        
        }
    

    @IBAction func didTapDeleteBtn(_ sender: Any) {
        self.present(alertConfirm, animated: true, completion: nil)
    }
    
}

extension DeletePopupViewViewController{
    
    func deleteDiary(){
        let url = "\(Constant.BASE_URL)/diarys/\(diaryIndex)/status"
        print(url)
        AF.request(url, method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: DeleteDiaryResponse.self){
            response in
            
            switch response.result {
                
            case .success(let response):
                print("Success>> deleteDiary \(response) ")
                
                //self.DeleteDiaryDelegate?.addDeleteDates()
                
                if response.code == 1000 {
                    
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print("DEBUG>> deleteDiary Error : \(error.localizedDescription)")
                
                
            }
        }
    }
}
