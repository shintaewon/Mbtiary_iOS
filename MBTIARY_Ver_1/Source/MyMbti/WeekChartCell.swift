//
//  WeekChartCell.swift
//  MBTIARY_Ver_1
//
//  Created by 신태원 on 2022/11/29.
//

import UIKit
import Charts

class WeekChartCell: UICollectionViewCell {
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var barCharts: BarChartView!
    @IBOutlet weak private var mostMBTILabel: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        barCharts.noDataFont = .systemFont(ofSize: 20)
        barCharts.noDataTextColor = .lightGray
        barCharts.pinchZoomEnabled = false
        barCharts.drawBarShadowEnabled = false
        barCharts.drawBordersEnabled = false
        barCharts.doubleTapToZoomEnabled = false
        barCharts.drawGridBackgroundEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setChart(week: Int, dataPoints: [String], values: [Double]) {
        // 데이터 생성
        label.text = "     \(week)주차 MBTI 🌱"
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "mbti 빈도 수")
        
        if dataEntries[0].y != 0 {
            mostMBTILabel.text = "     이번주는 \(dataPoints[0])의 성향을 가장 높게 보이셨네요 🤫"
        }
        else{
            mostMBTILabel.text = "     아직 이번주에 작성된 일기가 없네요 🤨"
        }

        // 차트 컬러
        chartDataSet.colors = [UIColor.systemGreen]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barCharts.data = chartData
        chartData.barWidth = Double(0.5)//width
        
        chartDataSet.highlightEnabled = false
        barCharts.doubleTapToZoomEnabled = false
        barCharts.xAxis.labelPosition = .bottom
        barCharts.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints )

        // X축 레이블 갯수 최대로 설정
        barCharts.xAxis.setLabelCount(dataPoints.count, force: false)
               
        barCharts.rightAxis.enabled = false
               
        // 애니메이션
        barCharts.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        barCharts.leftAxis.axisMaximum = 7
        barCharts.leftAxis.axisMinimum = 0
        barCharts.xAxis.drawGridLinesEnabled = false
        barCharts.xAxis.drawAxisLineEnabled = false
        barCharts.leftAxis.drawAxisLineEnabled = true
      //  barCharts.xAxis.enabled = false
        barCharts.gridBackgroundColor = UIColor.white
        //barCharts.setVisibleXRangeMinimum(9)
        //barCharts.setVisibleXRangeMaximum(15)
    }
}
