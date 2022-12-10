//
//  MonthViewController.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/29.
//

import UIKit
import Charts
import RxSwift
import Alamofire

final class MonthViewController: UIViewController, MBTIBindable, DatePickerManager {
    // MARK: - UIComponent
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak private var dayButton: UIButton!
    @IBOutlet weak private var weeklyButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak private var pieChartView: PieChartView!
    
    @IBOutlet weak var explainMonthMbtiLabel: UILabel!
    
    // MARK: - Variable, Constant
    private var disposeBag = DisposeBag()
    // MARK: - LifeCycle
    

    @IBAction func didTapWeeklyBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let selectDate = convertDate(in: datePicker.date).split { $0 == "-" }.map { Int($0)! }
        getMonthMBTI(year: selectDate[0], month: selectDate[1])
        monthLabel.text = "\(selectDate[1])월"
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
    }
    // MARK: - Configure
    private func configure() {
        setTopButtonUI()
        weeklyButton.addTarget(self, action: #selector(didTapDayButton), for: .touchDown)
    }
    // MARK: - Network
    private func requestMonthData(request: URLRequest) -> Observable<MonthMBTI> {
        return Observable.create { event in
            AF.request(request).responseDecodable(of: MonthMBTI.self) { response in
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
    
    private func getMonthMBTI(year: Int, month: Int) {
        let url = "http://mbtiary-env.eba-qzgygu4d.ap-northeast-2.elasticbeanstalk.com/users/\(Constant.userIndex)/mbti/month?year=\(year)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue( UserDefaults.standard.string(forKey: "JWT") ?? " ", forHTTPHeaderField: "X-ACCESS-TOKEN")
        requestMonthData(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                let result = data.result.filter { $0.month == month }
                let monthData = result.first!.userMbtiByMonth
                let mappingData = self?.mappingMBTI(userMbti: monthData)
                self?.customizeChart(dataPoints: (self?.convertKeys(data: mappingData!))!, values: (self?.convertValues(data: mappingData!))!)
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Action
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        let selectDate = convertDate(in: sender.date).split { $0 == "-" }.map { Int($0)! }
        print(selectDate)
        getMonthMBTI(year: selectDate[0], month: selectDate[1])
        monthLabel.text = "\(selectDate[1])월"
    }
    
    @objc private func didTapDayButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extension - ViewController
extension MonthViewController {
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
    // MARK: - Chart Setting
    func customizeChart(dataPoints: [String], values: [Double]) {//pie chart
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)


        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)

        print(dataEntries)
        if dataEntries[0].x != 0{
            explainMonthMbtiLabel.text = "이번달은 \(dataPoints[0])의 성향을 가장 높게 보이셨네요 🧐"
        }
        else{
            explainMonthMbtiLabel.text = "아직 이번달에 작성된 일기가 없네요 🤨"
        }
        pieChartView.data = pieChartData
    }
        
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
        }
        return colors
    }
    // MARK: - testFunc
    private func test() {
        let url = "http://mbtiary-env.eba-qzgygu4d.ap-northeast-2.elasticbeanstalk.com/users/\(Constant.userIndex)/mbti/month?year=2022"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue( UserDefaults.standard.string(forKey: "JWT") ?? " ", forHTTPHeaderField: "X-ACCESS-TOKEN")
        AF.request(request).responseData { result in
            print(String(data: result.data!, encoding: .utf8)!)
        }
    }
}

