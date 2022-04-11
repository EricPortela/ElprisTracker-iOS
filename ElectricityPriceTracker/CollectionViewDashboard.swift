//
//  CollectionViewDashboard.swift
//  ElectricityPriceTracker
//
//  Created by Eric Portela on 2022-04-11.
//

import UIKit

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
    
    private func setUpView() -> Void {
        self.layer.backgroundColor = UIColor(red: 0.43, green: 0.62, blue: 0.77, alpha: 1.00).cgColor
        self.layer.cornerRadius = 10
        
        
        let lblWidth: Int = Int(UIScreen.main.bounds.size.width - 60)
        let lblHeight = 25
        
        dashboardLbl.frame = CGRect(x: 20, y: 10, width: lblWidth, height: lblHeight)
        
        self.addSubview(dashboardLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
