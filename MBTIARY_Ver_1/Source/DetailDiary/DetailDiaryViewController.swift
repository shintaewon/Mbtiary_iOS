//
//  DetailDiaryViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/27.
//

import UIKit
import Alamofire
import Kingfisher

class DetailDiaryViewController: UIViewController {
    
    @IBOutlet weak var mbtiImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var diaryImg: UIImageView!
    @IBOutlet weak var diaryContent: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var clickedDiaryIndex : Int = 0
    var cratedAtDiary : Date = Date()
    
    var DetailContentResult : GetCalendarContentsResponse = GetCalendarContentsResponse(isSuccess: true, code: 0, message: "", result: [DiaryContents(contents: "", imgURL: "", createdAt: "", mbti: "", diaryIdx: 0)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCalendarContents()
        backgroundView.layer.cornerRadius = backgroundView.frame.height/2
        
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapSettingBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeletePopupViewViewController") as? DeletePopupViewViewController else{ return }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.diaryIndex = DetailContentResult.result[0].diaryIdx
       // vc.createdAt = DetailContentResult.result[0].createdAt
        self.present(vc, animated: true)
        
    }
    
    func weekday(year: Int, month: Int, day: Int) -> String? {
        
        let calendar = Calendar(identifier: .gregorian)
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: year, month: month, day: day)
            return comps.date
            }() else { return nil }
        
        let day = Calendar.current.component(.weekday, from: targetDate) - 1
        
        return Calendar.current.shortWeekdaySymbols[day] // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    //    return Calendar.current.standaloneWeekdaySymbols[day] // ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
    //    return Calendar.current.veryShortWeekdaySymbols[day] // ["S", "M", "T", "W", "T", "F", "S"]
    }
    
    
}

extension DetailDiaryViewController{
    
    func getCalendarContents(){
        let url = "\(Constant.BASE_URL)/diarys/\(clickedDiaryIndex)"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: GetCalendarContentsResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> getCalendarContents \(response) ")
                    
                    self.DetailContentResult = response
                    
                    if response.result[0].mbti != nil{
                        
                        let mbtiType = response.result[0].mbti
                        
                        self.mbtiImg.image = UIImage(named: (mbtiType) + ".png" )
                    }
                    else{
                        self.mbtiImg.image = UIImage(named: "nilmbti.png" )
                    }
                    
                    let time = response.result[0].createdAt.split(separator: "-")
                    self.dateLabel.text = time[0] + "년" + time[1] + "월 " + time[2] + "일"
                    let day = self.weekday(year: Int(time[0]) ?? 0, month: Int(time[1]) ?? 0, day: Int(time[2]) ?? 0)
                    
                    switch day
                    {
                    case "일":
                        self.dayLabel.text = "일요일"
                    case "월":
                        self.dayLabel.text = "월요일"
                    case "화":
                        self.dayLabel.text = "화요일"
                    case "수":
                        self.dayLabel.text = "수요일"
                    case "목":
                        self.dayLabel.text = "목요일"
                    case "금":
                        self.dayLabel.text = "금요일"
                    case "토":
                        self.dayLabel.text = "토요일"
                    default:
                        self.dayLabel.text = "일요일"
                    }
                    
                    let url = URL(string: response.result[0].imgURL)
                    
                    let processor = RoundCornerImageProcessor(cornerRadius: 10)
                    self.diaryImg.kf.setImage(with: url, options: [.processor(processor)])
                    
                    self.diaryImg.layer.cornerRadius = 10
                    self.diaryContent.text = response.result[0].contents
                    
                case .failure(let error):
                    print("DEBUG>> getCalendarContents Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
    }
    
}
