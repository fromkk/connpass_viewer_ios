//
//  CalendarViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/28.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import FKCalendarView

public final class CalendarViewController: UIViewController
{
    public var date: NSDate = NSDate() {
        didSet {
            if !self.isViewLoaded()
            {
                return
            }
            
            self.headerView.dateLabel.text = self.date.stringWithFormat("yyyy/MM")
        }
    }
    public lazy var calendarView: FKCalendarView = {
        let result: FKCalendarView = FKCalendarView(frame: self.view.bounds, date: self.date)
        result.weekdayHeight = 24.0
        result.calendarDelegate = self
        result.registerClass(FKCalendarViewWeekCell.self, forCellWithReuseIdentifier: FKCalendarViewWeekCell.cellIdentifier)
        result.registerClass(FKCalendarViewDateCell.self, forCellWithReuseIdentifier: FKCalendarViewDateCell.cellIdentifier)
        return result
    }()
    public lazy var headerView: FKCalendarHeaderView = {
        let result: FKCalendarHeaderView = FKCalendarHeaderView(frame: CGRect(x: 0.0, y: -88.0, width: self.view.frame.size.width, height: 88.0))
        return result
    }()
    private lazy var closeButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("close", comment: "close"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.onCloseButtonDidTapped(_:)))
        return result
    }()
    
    public convenience init(date: NSDate)
    {
        self.init()
        defer {
            self.date = date
        }
    }
}

extension CalendarViewController
{
    public override func loadView() {
        super.loadView()
        
        self.navigationItem.leftBarButtonItem = self.closeButton
        self.view.addSubview(self.calendarView)
        self.calendarView.contentInset = UIEdgeInsets(top: 88.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.calendarView.addSubview(self.headerView)
        
        self.headerView.dateLabel.text = self.date.stringWithFormat("yyyy/MM")
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.calendarView.frame = self.view.bounds
    }
}

extension CalendarViewController: FKCalendarViewDelegate
{
    public func dequeueReusableWeekdayCellWithCalendarView(calendarView: FKCalendarView, indexPath: NSIndexPath, weekDay: FKCalendarViewWeekday) -> UICollectionViewCell {
        guard let cell: FKCalendarViewWeekCell = calendarView.dequeueReusableCellWithReuseIdentifier(FKCalendarViewWeekCell.cellIdentifier, forIndexPath: indexPath) as? FKCalendarViewWeekCell else
        {
            fatalError("FKCalendarWeekdayCell initialize failed")
        }
        cell.weekLabel.text = weekDay.toString()
        return cell
    }
    
    public func dequeueReusableDateCellWithCalendarView(calendarView: FKCalendarView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        guard let cell: FKCalendarViewDateCell = calendarView.dequeueReusableCellWithReuseIdentifier(FKCalendarViewDateCell.cellIdentifier, forIndexPath: indexPath) as? FKCalendarViewDateCell else
        {
            fatalError("FKCalendarDateCell initialize failed")
        }
        cell.dateLabel.text = String(date.day)
        if date.month == self.date.month
        {
            cell.dateLabel.textColor = ConnpassColor.textColor
            cell.userInteractionEnabled = true
        } else
        {
            cell.dateLabel.textColor = ConnpassColor.lightColor
            cell.userInteractionEnabled = false
        }
        return cell
    }
    
    public func calendarView(calendarView: FKCalendarView, didSelectDayCell cell: UICollectionViewCell, date: NSDate) {
        guard let cell: FKCalendarViewDateCell = cell as? FKCalendarViewDateCell else
        {
            fatalError("FKCalendarViewDateCell get failed")
        }
        
        
    }
}

private protocol CalendarViewControllerEvents
{
    func onCloseButtonDidTapped(button: UIBarButtonItemStyle) -> Void
}

extension CalendarViewController: CalendarViewControllerEvents
{
    @objc private func onCloseButtonDidTapped(button: UIBarButtonItemStyle) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}