//
//  ViewController.swift
//  ElectricityPriceTracker
//
//  Created by Eric Portela on 2022-04-09.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayDateLbl: UILabel!
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current

    
    var timeStamps: [Date] = [] //[Date] = []
    var prices: [Double] = []
    var lowestAndAveragePrice: (Double, Double) = (0,0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDateFormatter()
        
        scrapePage(url: "https://elen.nu/dagens-spotpris/se4-malmo/")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewDashboard.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "dashboardHeader")
        
        setDayAndDate()
    }
    
    private func setUpDateFormatter() -> Void {
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "sv_SE")
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm"
    }
    
    private func setDayAndDate() -> Void {
        let dateFormatter1 = DateFormatter()
        let dateFormatter2 = DateFormatter()
        
        let currentDate = Date() //sets constant date to current date
        dateFormatter1.dateFormat = "EEEE" //Format that only gets the day
        dateFormatter2.dateFormat = "d MMMM yyyy"
        
        let weekDay: String = dateFormatter1.string(from: currentDate) + "\n"
        let date: String = dateFormatter2.string(from: currentDate)
                
        let firstFont = UIFont(name: "HelveticaNeue-Bold", size: 30)
        let secondFont = UIFont(name: "HelveticaNeue", size: 18)
                
        let firstAttributes = [NSAttributedString.Key.font: firstFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let secondAttributes = [NSAttributedString.Key.font: secondFont, NSAttributedString.Key.foregroundColor: UIColor.gray]

        let firstAttributedString = NSMutableAttributedString(string: weekDay, attributes: firstAttributes)
        let secondAttributedString = NSMutableAttributedString(string: date, attributes: secondAttributes)
        
        firstAttributedString.append(secondAttributedString)
        
        dayDateLbl.attributedText = firstAttributedString
        
        
        
    }
    
    private func getCheapest(data: (Array<Date>, Array<Double>)) -> (Date, Double) {
        
        var date: Date = Date()
        var price: Double = 0
        
        if let cheapestPrice = prices.min(){
            if let index = prices.firstIndex(of: cheapestPrice) {
                let cheapestDate = data.0[index]
                
                date = cheapestDate
                price = cheapestPrice
            }
        }
        return (date, price)
    }
    
    private func getAveragePrice(data: Array<Double>) -> Double {
        var sum: Double = 0
        var average: Double = 0
        
        for i in data {
            sum += i
        }
        
        average = sum/Double(data.count)
        
        return average
    }
    
    
    private func scrapePage (url: String) -> Void {
        
        DispatchQueue.main.async {
            do {
                
                if let url = URL(string: url) {
                    do {
                        let html = try String(contentsOf: url)
                        
                        let doc: Document = try SwiftSoup.parse(html)
                        
                        let table: Element = try doc.select("table").first()!
                        
                        let data: Element = try table.select("tbody").first()!
                                            
                        for i in data.children() {
                            
                            let period: String = try i.select("td").first()!.text()
                            print(period)
                            let price: String = try i.select("td").last()!.text().replacingOccurrences(of: " öre/kWh", with: "")
                            
                            if let priceDouble = (price as? NSString)?.doubleValue {
                                if let date = self.dateFormatter.date(from: period) {
                                    self.timeStamps.append(date)
                                    self.prices.append(priceDouble)
                                }
                            }
                            
                            /*
                            if let date = dateFormatter.date(from: period){
                                timeStamps.append(date)
                                prices.append(price)
                            }
                             */
                            
                        }
                        
                        let cheapestDatapoint = self.getCheapest(data: (self.timeStamps, self.prices))
                        let averagePrice = self.getAveragePrice(data: self.prices)
                        
                        let cheapestTime = cheapestDatapoint.0
                        let cheapestPrice = cheapestDatapoint.1
                        
                        let hour = String(self.calendar.component(.hour, from: cheapestTime))
                        
                        self.lowestAndAveragePrice = (cheapestPrice, averagePrice)
                        
                        self.collectionView.reloadData()
                        //self.cheapestHour.text = hour + ":00"
                        //self.cheapestPrice.text = String(format: "%.2f", cheapestHour) + " öre/kWh"
                    }
                    
                    catch {
                        print("Could not parse HTML correctly")
                    }
                    
                } else {
                    print("Not a valid URL")
                }
            }
            
            //timeStamps.reverse()
            //prices.reverse()
        }
        }
        
        
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return prices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        
        //cell?.timeFrame.layer.cornerRadius = 10        
        cell?.contentView.layer.cornerRadius = 2.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        cell?.contentView.layer.cornerRadius = 10
        cell?.contentView.layer.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00).cgColor
        
        let hour = String(calendar.component(.hour, from: (timeStamps[indexPath.row])))

        cell?.dateLbl.text = hour + ":00"
                
        cell?.priceLbl.text = String(format: "%.2f", prices[indexPath.row]) + " öre/kWh"
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (CGFloat(UIScreen.main.bounds.size.width)) - 40
        let height: CGFloat = 115
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dashboardHeader", for: indexPath) as? CollectionViewDashboard
        
        let lowest = lowestAndAveragePrice.0
        let average = lowestAndAveragePrice.1
        
        header?.setLowestPrice(price: lowest)
        header?.preparePieChartData(lowestPrice: lowest, averagePrice: average)
        
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.size.width - 40
        
        let height: CGFloat = 200
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
}
