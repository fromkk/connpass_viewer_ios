//
//  FKCalendarViewCell.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/28.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

class FKCalendarViewWeekCell: UICollectionViewCell
{
    static let cellIdentifier: String = "FKCalekdarViewWeekCell"
    lazy var weekLabel: UILabel = {
        let result: UILabel = UILabel()
        result.textAlignment = NSTextAlignment.Center
        result.font = UIFont.systemFontOfSize(9.0)
        result.layer.masksToBounds = true
        result.layer.cornerRadius = 6.0
        result.backgroundColor = ConnpassColor.lightColor
        result.textColor = ConnpassColor.textColor
        result.numberOfLines = 1
        return result
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.weekLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.weekLabel.frame = self.bounds
    }
}

class FKCalendarViewDateCell: UICollectionViewCell
{
    static let cellIdentifier: String = "FKCalendarViewDateCell"
    
    lazy var selectedView: UIView = {
        let result: UIView = UIView()
        result.backgroundColor = ConnpassColor.redColor
        result.layer.masksToBounds = true
        result.layer.cornerRadius = 12.0
        result.frame = CGRect(x: (self.frame.size.width - 24.0) / 2.0, y: (self.frame.size.height - 24.0) / 2.0, width: 24.0, height: 24.0)
        result.hidden = true
        return result
    }()
    
    lazy var dateLabel: UILabel = {
        let result: UILabel = UILabel()
        result.textColor = ConnpassColor.themeColor
        result.textAlignment = NSTextAlignment.Center
        result.numberOfLines = 1
        result.font = UIFont.systemFontOfSize(12.0)
        return result
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.selectedView)
        self.addSubview(self.dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedView.frame = CGRect(x: (self.frame.size.width - 24.0) / 2.0, y: (self.frame.size.height - 24.0) / 2.0, width: 24.0, height: 24.0)
        self.dateLabel.frame = self.bounds
    }
    
    override var selected: Bool {
        didSet {
            if self.selected
            {
                self.selectedView.hidden = false
                self.dateLabel.textColor = UIColor.whiteColor()
            } else
            {
                self.selectedView.hidden = true
                self.dateLabel.textColor = ConnpassColor.textColor
            }
        }
    }
}