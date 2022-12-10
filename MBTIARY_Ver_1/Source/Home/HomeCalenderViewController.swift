//
//  HomeCalenderViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/25.
//

import UIKit
import FSCalendar
import Alamofire
import Kingfisher

class HomeCalenderViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    
    @IBOutlet weak var newMbtiaryBtn: UIButton!
    
    
    @IBOutlet weak var diaryTableView: UITableView!
    
    var CalendarDateResult : CalendarDateResponse = CalendarDateResponse(isSuccess: true, code: 0, message: "", result: [DataResult(diaryIdx: 0, createdAt: "")])
    
    var CalendarContents : GetCalendarContentsResponse = GetCalendarContentsResponse(isSuccess: true, code: 0, message: "", result: [DiaryContents(contents: " ", imgURL: " ", createdAt: " ", mbti: " ", diaryIdx: 0)])
    var dates : [Date] = []
    
    var clickedDiaryIndex : Int = 0
    
    var imageView : UIImageView = UIImageView()
    
    @IBAction func didTapNewMbtiary(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let current_date_string = formatter.string(from: Date())
        
        if CalendarDateResult.result.last?.createdAt == current_date_string {
            self.presentBottomAlert(message: "MBTIARY는 하루에 하나만 작성할 수 있어요!")
        }
        else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewDiaryViewController") as? NewDiaryViewController else{
                return
            }
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true)
        }
        
        /*guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewDiaryViewController") as? NewDiaryViewController else{
            return
        }
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true)*/
        
        
    }
    
    
    @IBAction func didTapMyPageBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else{
            return
        }
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.set(" ", forKey: "JWT")
        //UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        Constant.userIndex = UserDefaults.standard.integer(forKey: "userIndex")
        print(UserDefaults.standard.string(forKey: "JWT"))
        print("나 몇번이니?", Constant.userIndex)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        calendar.delegate = self
        calendar.dataSource = self
        
        getCalendarContents()
        
        // 달력의 년월 글자 바꾸기
        calendar.appearance.headerDateFormat = "YYYY년 M월"

        // 달력의 요일 글자 바꾸는 방법 1
        calendar.locale = Locale(identifier: "ko_KR")
                
        // 년월에 흐릿하게 보이는 애들 없애기
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.backgroundColor = UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        calendar.appearance.todayColor = UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        calendar.appearance.selectionColor = UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        
        calendar.appearance.eventDefaultColor = UIColor(hex: 0x009900, alpha: 1)
        calendar.appearance.eventSelectionColor = UIColor(hex: 0x009900, alpha: 1)
        
        
        newMbtiaryBtn.layer.cornerRadius = newMbtiaryBtn.layer.frame.height/2
        newMbtiaryBtn.layer.shadowColor = UIColor.black.cgColor // 색깔
        newMbtiaryBtn.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        newMbtiaryBtn.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        newMbtiaryBtn.layer.shadowRadius = 5 // 반경
        newMbtiaryBtn.layer.shadowOpacity = 0.3 // alpha값
        
        
        let noDirayPic = UIImage(named: "noDiary.png")
        imageView = UIImageView(image: noDirayPic!)
        imageView.frame = CGRect(x: 20, y: 470, width: 350, height: 170)
        imageView.contentMode = .scaleAspectFit
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        dates.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCalendarDate()
        print("viewWillAppear")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
      
        calendar.reloadData()
        diaryTableView.reloadData()
        
        
        if (UserDefaults.standard.bool(forKey: "isFirstLaunch") == true) {
            //print("왜 실행안돼1")
            guard let splashVc = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenViewController") as? SplashScreenViewController else {
                return
            }
            //print("왜 실행안돼2")
            splashVc.modalPresentationStyle = .fullScreen
            
            self.present(splashVc, animated: false, completion: nil)

        }
        
        
        showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissIndicator()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendar.reloadData()
    }

}

extension HomeCalenderViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    /*func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "TestViewController") as? TestViewController else { return }
        
        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.date = dateFormatter.string(from: date)

        self.present(modalPresentView, animated: true, completion: nil)
    }*/
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.dates.contains(date){
            return 1
        }
        else{
            return 0
        }
        
    }
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let temp = CalendarDateResult.result.firstIndex(where: { $0.createdAt == formatter.string(from: date) }) ?? -1
        
        print("뭐가 선택?:", temp)
        if temp >= 0 {
            clickedDiaryIndex = CalendarDateResult.result[temp].diaryIdx
            getCalendarContents()
        }
        else{
            clickedDiaryIndex = 0
            getCalendarContents()
        }
        print(formatter.string(from: date) + " 선택됨")
    }
    
}


extension HomeCalenderViewController{
    
    func getCalendarDate(){
        let url = "\(Constant.BASE_URL)/home/calendar"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: CalendarDateResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> GetCalendarDate \(response) ")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    if response.result.isEmpty == false{
                        let temp =  response.result.firstIndex(where: { $0.createdAt == formatter.string(from: Date()) }) ?? -1
                        self.CalendarDateResult = response
                        formatter.locale = Locale(identifier: "ko_KR")
                        formatter.dateFormat = "yyyy-MM-dd"
                        //self.dates.removeAll()
                        for i in 0..<self.CalendarDateResult.result.count{
                            let sampledate = formatter.date(from: self.CalendarDateResult.result[i].createdAt)
                            //print(self.CalendarDateResult.result[i].createdAt)
                            
                            self.dates.append(sampledate!)
                        }
                        
                        if temp >= 0 {
                            print("이게 실행?")
                            
                            self.clickedDiaryIndex = response.result[temp].diaryIdx
                    
                            self.getCalendarContents()
                
                            print(self.dates)
                            self.calendar.reloadData()
                            
                            
                          
                            
                        }
                        else{
                            print("설마 너가실행되고있니")
                            self.clickedDiaryIndex = 0
                            self.getCalendarContents()
                        }
                        
                    }
                    
                case .failure(let error):
                    print("DEBUG>> GetCalendarDate Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
    }
    
    
    func getCalendarContents(){
        let url = "\(Constant.BASE_URL)/diarys/\(clickedDiaryIndex)"
        print(url)
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: GetCalendarContentsResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> getCalendarContents \(response) ")
                    
                    self.CalendarContents = response
                    self.diaryTableView.reloadData()
                    
                case .failure(let error):
                    print("DEBUG>> getCalendarContents Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
    }
}

extension HomeCalenderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailDiaryViewController") as? DetailDiaryViewController else{
            return
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        vc.clickedDiaryIndex = self.clickedDiaryIndex
        present(vc, animated: true)
        
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell", for: indexPath) as? DiaryTableViewCell else{
            
            return UITableViewCell()
        }
        
        
        print(clickedDiaryIndex)
        //print(CalendarContents)
        if CalendarContents.result.count != 0 {
            tableView.allowsSelection = true
            imageView.isHidden = true
            cell.dateLabel.text = CalendarContents.result[indexPath.row].createdAt
            cell.contentsLabel.text = CalendarContents.result[indexPath.row].contents
            
            
            let url = URL(string: CalendarContents.result[indexPath.row].imgURL)
            
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            cell.diaryImage.kf.setImage(with: url, options: [.processor(processor)])
            
        }
        else{
            tableView.allowsSelection = false
            imageView.isHidden = false
            cell.dateLabel.text = ""
            cell.contentsLabel.text = ""
            cell.diaryImage.image = nil
            view.addSubview(imageView)
        }
        
        
        
        return cell
    }
    
    
}
