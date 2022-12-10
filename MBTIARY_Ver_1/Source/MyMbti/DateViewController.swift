//
//  DateViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/29.
//

import UIKit
import Alamofire
import RxSwift


final class DateViewController: UIViewController, MBTIBindable, DatePickerManager {
    // MARK: - UIComponent
    @IBOutlet weak private var dayButton: UIButton!
    @IBOutlet weak private var weeklyButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    @IBOutlet weak private var dailyMBTILabel: UILabel!
    // MARK: - Variable, Constant
    @IBOutlet weak var publicDiaryBtn: UIButton!
    private var dailyMBTI: DailyMBTI?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var shareLabel: UILabel!
    
    var recommandedInedx : Int = 0
    var imageView : UIImageView = UIImageView()
    // MARK: - LifeCycle
    
    
    @IBAction func didTapWeeklyBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeeklyViewController") as? WeeklyViewController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let current_date_string = formatter.string(from: Date())
        
        configure()
        test(date: convertDate(in: Date()))
        getDayMBTI(date: convertDate(in: Date()))
        
        shareLabel.text = """
                        당신과 같은 mbti를 가진 분들은
                        어떤 일상을 보냈을까요?
                        일상과 생각을 함께 공유해 보세요!
                        """
    }
    
    override func viewWillAppear(_ animated: Bool) {
        test(date: convertDate(in: Date()))
        getDayMBTI(date: convertDate(in: Date()))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.imageView.isHidden = true
    }
    // MARK: - Configure
    private func configure() {
        setTopButtonUI()

    }
    // MARK: - data
    private func getDayMBTI(date: String) {
        let url = "http://mbtiary-env.eba-qzgygu4d.ap-northeast-2.elasticbeanstalk.com/users/\(Constant.userIndex)/mbti/day?date=\(date)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue( UserDefaults.standard.string(forKey: "JWT") ?? " ", forHTTPHeaderField: "X-ACCESS-TOKEN")
        requestDayData(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dailyMBTI in
                self?.dailyMBTI = dailyMBTI
                let mbti = dailyMBTI.result.mbti
                self?.dailyMBTILabel.text = (self?.form(name: UserDefaults.standard.string(forKey: "nickName") ?? "", date: date))! + (self?.dailyMBTIbinding(mbti: mbti))!
                self?.dailyMBTILabel.textAlignment = .center
            })
            .disposed(by: disposeBag)
    }
    
    private func requestDayData(request: URLRequest) -> Observable<DailyMBTI> {
        return Observable.create { event in
            AF.request(request).responseDecodable(of: DailyMBTI.self) { response in
                switch response.result {
                case .success(let result):
                    event.onNext(result)
                    event.onCompleted()
                    self.shareLabel.isHidden = false
                    self.publicDiaryBtn.isHidden = false
                    self.imageView.isHidden = true
                    self.dailyMBTILabel.isHidden = false
                    self.recommandedInedx = self.dailyMBTI?.result.recommendationDiaryIdx ?? -1
                    print(self.recommandedInedx)
                    print("success")
                    
                case .failure(let error):
                    event.onError(error)
                    self.imageView.isHidden = false
                    let imageName = "noTodayDiary.png"
                    let image = UIImage(named: imageName)
                    self.imageView = UIImageView(image: image!)
                    self.imageView.contentMode = .scaleAspectFill
                    self.imageView.backgroundColor = .black
                    self.imageView.frame = CGRect(x: 17, y: 140, width: 355, height: 450)
                    self.view.addSubview(self.imageView)
                    self.dailyMBTILabel.isHidden = true
                    self.shareLabel.isHidden = true
                    self.publicDiaryBtn.isHidden = true
                    print("failure")
                }
            }
            return Disposables.create {
                
            }
        }
    }
    // MARK: - Action
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        getDayMBTI(date: convertDate(in: sender.date))
        test(date: convertDate(in: sender.date))
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction private func didTapMoveButtion(_ sender: Any) {
        guard let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "DailyContentViewController") as? DailyContentViewController else {
            return
        }
        //contentVC.
        contentVC.modalTransitionStyle = .coverVertical
        contentVC.modalPresentationStyle = .fullScreen
        contentVC.clickedDiaryIndex = recommandedInedx
        self.present(contentVC, animated: true)
        
        
    }
}
// MARK: - Extension - ViewController
extension DateViewController {
    private func setTopButtonUI() {
        let topButton = [dayButton, weeklyButton, monthButton]
        for button in topButton {
            button?.backgroundColor = UIColor(hex: 0x89c5f1)
            
            button?.layer.cornerRadius = 6.0
            button?.tintColor = .white
            button?.layer.shadowColor = UIColor.black.cgColor // 색깔
            button?.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
            button?.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
            button?.layer.shadowRadius = 5 // 반경
            button?.layer.shadowOpacity = 0.3 // alpha값
        }
    }
    private func test(date: String) {
        let url = "http://mbtiary-env.eba-qzgygu4d.ap-northeast-2.elasticbeanstalk.com/users/\(Constant.userIndex)/mbti/day?date=\(date)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue( UserDefaults.standard.string(forKey: "JWT") ?? " ", forHTTPHeaderField: "X-ACCESS-TOKEN")
        AF.request(request).responseData { result in
            print(String(data: result.data!, encoding: .utf8)!)
            print("test")
        }
    }
}
