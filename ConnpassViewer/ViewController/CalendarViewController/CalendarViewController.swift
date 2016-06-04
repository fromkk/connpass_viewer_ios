//
//  MonthViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/28.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import FKCalendarView

//MARK: CalendarViewController
public final class CalendarViewController: UIViewController
{
    public convenience init(date: NSDate) {
        self.init()
        
        defer {
            self.date = date
            if let prevDate: NSDate = self.date.prevMonth()
            {
                self.prevMonthViewController.date = prevDate
            }
            if let forwardDate: NSDate = self.date.forwardMonth()
            {
                self.forwardMonthViewController.date = forwardDate
            }
        }
    }
    
    public var date: NSDate = NSDate()
    public lazy var scrollView: UIScrollView = {
        let result: UIScrollView = UIScrollView()
        result.pagingEnabled = true
        result.showsVerticalScrollIndicator = false
        result.showsHorizontalScrollIndicator = false
        result.backgroundColor = UIColor.whiteColor()
        result.delegate = self
        return result
    }()
    public lazy var prevMonthViewController: MonthViewController = {
        let components: NSDateComponents = NSDateComponents()
        components.year = self.date.year
        components.month = self.date.month - 1
        components.day = 1
        let date: NSDate? = NSCalendar.sharedCalendar.dateFromComponents(components)
        
        let result: MonthViewController = MonthViewController(date: date ?? NSDate())
        result.delegate = self
        return result
    }()
    
    public lazy var currentMonthViewController: MonthViewController = {
        let result: MonthViewController = MonthViewController(date: self.date)
        result.delegate = self
        return result
    }()
    
    public lazy var forwardMonthViewController: MonthViewController = {
        let components: NSDateComponents = NSDateComponents()
        components.year = self.date.year
        components.month = self.date.month + 1
        components.day = 1
        let date: NSDate? = NSCalendar.sharedCalendar.dateFromComponents(components)
        
        let result: MonthViewController = MonthViewController(date: date ?? NSDate())
        result.delegate = self
        return result
    }()
    
    private func addMonthViewController(monthViewController: MonthViewController)
    {
        self.addChildViewController(monthViewController)
        self.scrollView.addSubview(monthViewController.view)
        monthViewController.didMoveToParentViewController(self)
    }
    
    private lazy var closeButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("close", comment: "close"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.onCloseButtonDidTapped(_:)))
        return result
    }()
}

public extension CalendarViewController
{
    public override func loadView() {
        super.loadView()
        
        self.navigationItem.leftBarButtonItem = self.closeButton
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.scrollView)
        self.addMonthViewController(self.prevMonthViewController)
        self.addMonthViewController(self.currentMonthViewController)
        self.addMonthViewController(self.forwardMonthViewController)
        
        self.layout()
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: self.scrollView.contentInset.top)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.layout()
    }
    
    private func layout() -> Void
    {
        var frame: CGRect = self.view.bounds
        self.scrollView.frame = frame
        self.prevMonthViewController.view.frame = frame
        
        frame.origin.x += frame.size.width
        self.currentMonthViewController.view.frame = frame
        
        frame.origin.x += frame.size.width
        self.forwardMonthViewController.view.frame = frame
        
        self.scrollView.contentSize = CGSize(width: frame.size.width * 3.0, height: frame.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom)
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

extension CalendarViewController: UIScrollViewDelegate
{
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrolling(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndScrolling(scrollView)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDidEndScrolling(scrollView)
    }
    
    private func scrollViewDidEndScrolling(scrollView: UIScrollView)
    {
        if scrollView.tracking || scrollView.dragging || scrollView.decelerating
        {
            return
        }
        
        if scrollView.contentOffset.x == self.scrollView.frame.size.width
        {
            return
        }
        
        if 0 == scrollView.contentOffset.x
        {
            scrollView.contentOffset.x = self.scrollView.frame.size.width
            if let date: NSDate = self.prevMonthViewController.date.prevMonth()
            {
                self.prevMonthViewController.date = date
            }
            
            if let date: NSDate = self.currentMonthViewController.date.prevMonth()
            {
                self.currentMonthViewController.date = date
            }
            
            if let date: NSDate = self.forwardMonthViewController.date.prevMonth()
            {
                self.forwardMonthViewController.date = date
            }
        } else if scrollView.contentOffset.x == scrollView.frame.size.width * 2.0
        {
            scrollView.contentOffset.x = self.scrollView.frame.size.width
            if let date: NSDate = self.prevMonthViewController.date.forwardMonth()
            {
                self.prevMonthViewController.date = date
            }
            
            if let date: NSDate = self.currentMonthViewController.date.forwardMonth()
            {
                self.currentMonthViewController.date = date
            }
            
            if let date: NSDate = self.forwardMonthViewController.date.forwardMonth()
            {
                self.forwardMonthViewController.date = date
            }
        }
    }
}

@objc public protocol MonthViewControllerDelegate : class
{
    func monthViewControllerPrev(monthViewController: MonthViewController) -> Void
    func monthViewControllerForward(monthViewController: MonthViewController) -> Void
    func monthViewController(monthViewController: MonthViewController, didSelectedDate date: NSDate) -> Void
}

extension CalendarViewController: MonthViewControllerDelegate {
    public func monthViewControllerPrev(monthViewController: MonthViewController) {
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.scrollView.contentOffset.y), animated: true)
    }
    
    public func monthViewControllerForward(monthViewController: MonthViewController) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * 2.0, y: self.scrollView.contentOffset.y), animated: true)
    }
    
    public func monthViewController(monthViewController: MonthViewController, didSelectedDate date: NSDate) {
        print(date)
    }
}

//MARK: MonthViewController
public final class MonthViewController: UIViewController
{
    public var date: NSDate = NSDate() {
        didSet {
            if !self.isViewLoaded()
            {
                return
            }
            
            self.headerView.dateLabel.text = self.date.stringWithFormat("yyyy/MM")
            self.calendarView.date = self.date
            self.calendarView.reloadData()
        }
    }
    public lazy var calendarView: FKCalendarView = {
        let result: FKCalendarView = FKCalendarView(frame: self.view.bounds, date: self.date)
        result.weekdayHeight = 24.0
        result.calendarDelegate = self
        result.registerClass(FKCalendarViewWeekCell.self, forCellWithReuseIdentifier: FKCalendarViewWeekCell.cellIdentifier)
        result.registerClass(FKCalendarViewDateCell.self, forCellWithReuseIdentifier: FKCalendarViewDateCell.cellIdentifier)
        result.registerClass(FKCalendarSelectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FKCalendarSelectionFooterView.viewIdentifier)
        return result
    }()
    public lazy var headerView: FKCalendarHeaderView = {
        let result: FKCalendarHeaderView = FKCalendarHeaderView(frame: CGRect(x: 0.0, y: -88.0, width: self.view.frame.size.width, height: 88.0))
        result.prevButton.addTarget(self, action: #selector(self.onPrevButtonDidTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        result.forwardButton.addTarget(self, action: #selector(self.onForwardButtonDidTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return result
    }()
    public weak var delegate: MonthViewControllerDelegate?
    public convenience init(date: NSDate)
    {
        self.init()
        defer {
            self.date = date
        }
    }
}

extension MonthViewController
{
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
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

extension MonthViewController: FKCalendarViewDelegate
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
        if date.month == self.date.month && date.year == self.date.year
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
        self.delegate?.monthViewController(self, didSelectedDate: date)
    }
    
    public func dequeueReusableSectionFooterWithCalendarView(calendarView: FKCalendarView, indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let view: FKCalendarSelectionFooterView = calendarView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: FKCalendarSelectionFooterView.viewIdentifier, forIndexPath: indexPath) as? FKCalendarSelectionFooterView else
        {
            return FKCalendarSelectionFooterView()
        }
        return view
    }
    
    public func sectionFooterSizeWithCalendarView(calendarView: FKCalendarView, section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 1.0)
    }
}

private protocol MonthViewControllerEvents {
    func onPrevButtonDidTapped(button: UIButton) -> Void
    func onForwardButtonDidTapped(button: UIButton) -> Void
}

extension MonthViewController: MonthViewControllerEvents {
    @objc private func onPrevButtonDidTapped(button: UIButton) {
        self.delegate?.monthViewControllerPrev(self)
    }
    
    @objc private func onForwardButtonDidTapped(button: UIButton) {
        self.delegate?.monthViewControllerForward(self)
    }
}
