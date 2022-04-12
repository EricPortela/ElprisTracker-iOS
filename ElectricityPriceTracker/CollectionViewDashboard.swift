//
//  CollectionViewDashboard.swift
//  ElectricityPriceTracker
//
//  Created by Eric Portela on 2022-04-11.
//

import UIKit
import Charts

class CollectionViewDashboard: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    let cellWidth = Int(UIScreen.main.bounds.size.width - 40)
    let cellHeight = 80
    
    let dashboardLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Billigaste elen idag"
        lbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return lbl
    }()
    
    let pieChart: PieChartView = {
        let chart = PieChartView()
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        chart.holeColor = UIColor.clear
        chart.holeRadiusPercent = 0.8
        chart.rotationEnabled = false
        chart.minOffset = 0
        chart.legend.enabled = false //remove the legend/color box
        return chart
    }()
    
    
    let priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    public func preparePieChartData(lowestPrice: Double?, averagePrice: Double?) -> Void {
        var entry: [PieChartDataEntry] = []
        var ratio: Double = 0
        
        if let unwrappedLow = lowestPrice, let unwrappedAvg = averagePrice {
            entry.append(PieChartDataEntry(value: unwrappedLow))
            entry.append(PieChartDataEntry(value: unwrappedAvg - unwrappedLow))
            ratio = (unwrappedLow/unwrappedAvg)*100
        }
        
        
        let dataSet = PieChartDataSet(entries: entry, label: "")
        dataSet.selectionShift = 0
        dataSet.highlightEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.colors = [UIColor(red: 0.01, green: 0.81, blue: 0.64, alpha: 1.00), UIColor(red: 0.43, green: 0.45, blue: 0.47, alpha: 1.00)]
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        pieChart.centerText = String(format: "%.2f", ratio) + "%"
    }
    
    public func setLowestPrice(price: Double?) -> Void {
        
        let firstFont = UIFont(name: "HelveticaNeue-Medium", size: 10)
        let secondFont = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        let firstDict: NSDictionary = NSDictionary(object: firstFont, forKey: NSAttributedString.Key.font as NSCopying)
        let secondDict: NSDictionary = NSDictionary(object: secondFont, forKey: NSAttributedString.Key.font as NSCopying)

        let firstText = "Timpris\n"
        let firstAttributedString = NSMutableAttributedString(string: firstText, attributes: firstDict as? [NSAttributedString.Key : Any])
        
        if let unwrappedPrice = price {
            let secondText = String(format: "%.2.f", unwrappedPrice) + " öre/kWH"
            let secondAttributedString = NSMutableAttributedString(string: secondText, attributes: secondDict as? [NSAttributedString.Key : Any])
            firstAttributedString.append(secondAttributedString)
            
            priceLbl.attributedText = firstAttributedString
        }
        
        
    }
    
    private func setUpView() -> Void {
        self.layer.backgroundColor = UIColor(red: 0.43, green: 0.62, blue: 0.77, alpha: 1.00).cgColor
        self.layer.cornerRadius = 10
        
        
        let lblWidth: Int = Int(UIScreen.main.bounds.size.width - 60)
        let lblHeight = 25
        
        dashboardLbl.frame = CGRect(x: 20, y: 10, width: lblWidth, height: lblHeight)
        self.addSubview(dashboardLbl)
        
        //Pie chart
        let pieX = CGFloat(cellWidth-90-20)
        let pieY = CGFloat(50)
        let pieWidth = CGFloat(90)
        let pieHeight = pieWidth
        
        pieChart.frame = CGRect(x: pieX, y: pieY, width: pieWidth, height: pieHeight)
        self.addSubview(pieChart)
        
        //Price label
        let priceWidth = CGFloat(170)
        let priceHeight = CGFloat(60)
        let priceX = CGFloat(20)
        let priceY = CGFloat(pieY+(pieWidth/2)-(priceHeight/2))
        
        priceLbl.frame = CGRect(x: priceX, y: priceY, width: priceWidth, height: priceHeight)
        self.addSubview(priceLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
