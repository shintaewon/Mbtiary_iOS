//
//  ListViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/10/27.
//

import UIKit
import MonthYearPicker
import Alamofire
import Kingfisher

class ListViewController: UIViewController {

    @IBOutlet weak var diaryListTableView: UITableView!
    
    var DiaryListResult : DiaryListResponse = DiaryListResponse(isSuccess: true, code: 0, message: " ", result: [DiaryListContents(contents: " ", imgURL: " ", createdAt: " ", diaryIdx: 0, mbti: " ")])
    var indexCount : Int = 0
    var nowYear : String = ""
    var nowMonth : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("??")
        
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 800) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        picker.maximumDate = Date()
        let time = Date().description.split(separator: "-")
        nowYear = String(time[0])
        nowMonth = String(time[1])
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        view.addSubview(picker)
        
        getDiaryList()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissIndicator()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        diaryListTableView.delegate = self
        diaryListTableView.dataSource = self
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        let time = picker.date.description.split(separator: "-")
        nowYear = String(time[0])
        nowMonth = String(time[1])
        getDiaryList()
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

extension ListViewController {
    
    func getDiaryList(){
        let url = "\(Constant.BASE_URL)/home/list"
        //home/list?year=2022&month=11
        let parameters: Parameters = [
            "year" : nowYear,
            "month" : nowMonth
        ]
        print(url)
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   headers: ["X-ACCESS-TOKEN" : "\(UserDefaults.standard.string(forKey: "JWT") ?? " ")"]).responseDecodable(of: DiaryListResponse.self){
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> DiaryListResponse \(response) ")
                    
                    self.indexCount = response.result.count - 1
                    
                    self.DiaryListResult = response
                    self.diaryListTableView.reloadData()
                    
                case .failure(let error):
                    print("DEBUG>> DiaryListResponse Error : \(error.localizedDescription)")
                    
                    
                    
                }
                }
    }
    
    
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailDiaryViewController") as? DetailDiaryViewController else{
            return
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        vc.clickedDiaryIndex = DiaryListResult.result[indexCount - indexPath.row].diaryIdx
        present(vc, animated: true)
        
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DiaryListResult.result.count == 0 {
            return 1
        }
        else{
            return DiaryListResult.result.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTableViewCell", for: indexPath) as? DiaryListTableViewCell else{
            
            return UITableViewCell()
        }
        
        if DiaryListResult.result.count != 0 {
            tableView.allowsSelection = true
            tableView.isScrollEnabled = true
            cell.mbtiImg.isHidden = false
            cell.dayLabel.isHidden = false
            cell.dateLabel.isHidden = false
            cell.diaryContent.isHidden = false
            
            let time = DiaryListResult.result[indexCount - indexPath.row].createdAt.split(separator: "-")
            cell.dateLabel.text = time[1] + "월 " + time[2] + "일"
            let day = weekday(year: Int(time[0]) ?? 0, month: Int(time[1]) ?? 0, day: Int(time[2]) ?? 0)
            print(day)
            
            switch day
            {
            case "일":
                cell.dayLabel.text = "일요일"
            case "월":
                cell.dayLabel.text = "월요일"
            case "화":
                cell.dayLabel.text = "화요일"
            case "수":
                cell.dayLabel.text = "수요일"
            case "목":
                cell.dayLabel.text = "목요일"
            case "금":
                cell.dayLabel.text = "금요일"
            case "토":
                cell.dayLabel.text = "토요일"
            default:
                cell.dayLabel.text = "일요일"
            }
            
            cell.diaryContent.text = DiaryListResult.result[indexCount - indexPath.row].contents
            
            let url = URL(string: DiaryListResult.result[indexCount - indexPath.row].imgURL)
            
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            cell.diaryImg.kf.setImage(with: url, options: [.processor(processor)])
        
            
           /* DispatchQueue.main.async {
                if url != nil{
                    do
                    {
                        let data = try Data(contentsOf: url!)
                        //cell.diaryImg.frame.size = CGSize(width: 343, height: 350)
                        cell.diaryImg.image = UIImage(data: data)?.withRoundedCorners(radius: 10)
                        
                    }
                    catch
                    {
                            
                    }
                }
            }*/
            
            if DiaryListResult.result[indexCount - indexPath.row].mbti != nil{
                
                let mbtiType = DiaryListResult.result[indexCount - indexPath.row].mbti
                
                cell.mbtiImg.image = UIImage(named: (mbtiType ?? " ") + ".png" )
            }
            else{
                cell.mbtiImg.image = UIImage(named: "nilmbti.png" )
            }
            return cell
        }
        else{
            tableView.allowsSelection = false
            tableView.isScrollEnabled = false
            cell.mbtiImg.isHidden = true
            cell.dayLabel.isHidden = true
            cell.dateLabel.isHidden = true
            cell.diaryContent.isHidden = true
            //cell.diaryImg.frame.size = CGSize(width: 380, height: 350)
            cell.diaryImg.image = UIImage(named: "noDiary.png")
            
            
            return cell
            //MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 800) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        }
        
    }
    
    
}
