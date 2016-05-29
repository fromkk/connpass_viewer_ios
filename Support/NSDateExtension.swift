//
//  NSDateExtension.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

internal extension NSCalendar
{
    static var sharedCalendar: NSCalendar {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.locale = NSLocale.systemLocale()
        calendar.timeZone = NSTimeZone.systemTimeZone()
        return calendar
    }
}

public extension NSDate
{
    func stringWithFormat(format: String) -> String
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    func prevMonth(month: Int = 1) -> NSDate?
    {
        let components: NSDateComponents = NSCalendar.sharedCalendar.components([.Year, .Month, .Day], fromDate: self)
        components.day = 1
        components.month -= month
        return NSCalendar.sharedCalendar.dateFromComponents(components)
    }
    
    func forwardMonth(month: Int = 1) -> NSDate?
    {
        let components: NSDateComponents = NSCalendar.sharedCalendar.components([.Year, .Month, .Day], fromDate: self)
        components.day = 1
        components.month += month
        return NSCalendar.sharedCalendar.dateFromComponents(components)
    }
}

public extension String
{
    func dateFromFormat(format: String) -> NSDate?
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        formatter.dateFormat = format
        return formatter.dateFromString(self)
    }
}
