//
//  FKCalendarHeaderView.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/29.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import FKCalendarView

public class FKCalendarHeaderView: UIView
{
    public lazy var prevButton: UIButton = {
        let result: UIButton = UIButton()
        result.setImage(UIImage(named: "ic_prev"), forState: UIControlState.Normal)
        result.contentMode = UIViewContentMode.Center
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    public lazy var forwardButton: UIButton = {
        let result: UIButton = UIButton()
        result.setImage(UIImage(named: "ic_forward"), forState: UIControlState.Normal)
        result.contentMode = UIViewContentMode.Center
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    public lazy var dateLabel: UILabel = {
        let result: UILabel = UILabel()
        result.font = UIFont.systemFontOfSize(18.0)
        result.textAlignment = NSTextAlignment.Center
        result.textColor = ConnpassColor.textColor
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.prevButton)
        self.addSubview(self.forwardButton)
        self.addSubview(self.dateLabel)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.dateLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.prevButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.prevButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.dateLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: self.forwardButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.forwardButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.dateLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 16.0)
        ])
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
