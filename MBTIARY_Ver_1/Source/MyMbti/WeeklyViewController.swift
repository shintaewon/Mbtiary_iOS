//
//  WeeklyViewController.swift
//  chartt
//
//  Created by 정혜윤 on 2022/11/26.
//

import UIKit
import RxSwift
import Alamofire
import Charts
import MonthYearPicker

final class WeeklyViewController: UIViewController, MBTIBindable, DatePickerManager {
    // MARK: - UIComponent
    @IBOutlet weak private var monthLabel: UILabel!
    @IBOutlet weak private var dayButton: UIButton!
    @IBOutlet weak private var weeklyButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak private var chartCollectionView: UICollectionView!
    
    // MARK: - Variable, Constant
    private var weeklyMBTI: WeeklyMBTI?
    private var disposeBag = DisposeBag()
    
    
    @IBAction func didTapDailyBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapMonthlyBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MonthViewController") as? MonthViewController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setTopButtonUI()
        let selectDate = convertDate(in: datePicker.date).split { $0 == "-" }.map { Int($0)! }
        getWeeklyMBTI(year: selectDate[0], month: selectDate[1])
        monthLabel.text = "\(selectDate[1])월"
        
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
    }
    // MARK: - configure
    private func configure() {
        chartCollectionView.dataSource = self
        dayButton.addTarget(self, action: #selector(didTapDayButton), for: .touchDown)
        
    }
    // MARK: - Data
    private func getWeeklyMBTI(year: Int, month: Int) {//weakly 서버
        let url = "http://mbtiary-env.eba-qzgygu4d.ap-northeast-2.elasticbeanstalk.com/users/\(Constant.userIndex)/mbti/week?year=\(year)&month=\(month)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue( UserDefaults.standard.string(forKey: "JWT") ?? " ", forHTTPHeaderField: "X-ACCESS-TOKEN")
        requestWeeklyData(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print(data.result)
                self?.weeklyMBTI = data
                self?.chartCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestWeeklyData(request: URLRequest) -> Observable<WeeklyMBTI> {//weakly alamofire
        return Observable.create { event in
            AF.request(request).responseDecodable(of: WeeklyMBTI.self) { response in
                switch response.result {
                case .success(let result):
                    event.onNext(result)
                    event.onCompleted()
                case .failure(let error):
                    event.onError(error)
                }
            }
            return Disposables.create {
                
            }
        }
    }
    // MARK: - Action
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        let selectDate = convertDate(in: sender.date).split { $0 == "-" }.map { Int($0)! }
        print(selectDate)
        getWeeklyMBTI(year: selectDate[0], month: selectDate[1])
        monthLabel.text = "\(selectDate[1])월"
    }
    
    @objc private func didTapDayButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extension - ViewController
extension WeeklyViewController {
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
}
// MARK: - Extension - UICollectionView DataSource
extension WeeklyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WeekChartCell else {
            return UICollectionViewListCell()
        }
        
        guard let mbti = weeklyMBTI else { return cell }
        
        switch indexPath.item {
        case 0:
            let data = mappingMBTI(userMbti: mbti.result[0].userMbtiByWeek)
            cell.setChart(week: 1, dataPoints: convertKeys(data: data), values: convertValues(data: data))
        case 1:
            let data = mappingMBTI(userMbti: mbti.result[1].userMbtiByWeek)
            cell.setChart(week: 2, dataPoints: convertKeys(data: data), values: convertValues(data: data))
        case 2:
            let data = mappingMBTI(userMbti: mbti.result[2].userMbtiByWeek)
            cell.setChart(week: 3, dataPoints: convertKeys(data: data), values: convertValues(data: data))
        case 3:
            let data = mappingMBTI(userMbti: mbti.result[3].userMbtiByWeek)
            cell.setChart(week: 4, dataPoints: convertKeys(data: data), values: convertValues(data: data))
        default:
            print("asd")
        }
        return cell
    }
}
