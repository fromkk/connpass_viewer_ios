//
//  NSDateExtension.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

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