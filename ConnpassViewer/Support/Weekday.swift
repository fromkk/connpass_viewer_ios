//
//  Weekday.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/28.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import FKCalendarView

extension FKCalendarViewWeekday
{
    func toString() -> String
    {
        switch self
        {
        case .Sunday:
            return NSLocalizedString("weekday.sunday", comment: "Sun.")
        case .Monday:
            return NSLocalizedString("weekday.monday", comment: "Mon.")
        case .Tuesday:
            return NSLocalizedString("weekday.tuesday", comment: "Tue.")
        case .Wednesday:
            return NSLocalizedString("weekday.wednesday", comment: "Wed.")
        case .Thursday:
            return NSLocalizedString("weekday.thursday", comment: "Thu.")
        case .Friday:
            return NSLocalizedString("weekday.friday", comment: "Fri.")
        case .Saturday:
            return NSLocalizedString("weekday.saturday", comment: "Sat.")
        }
    }
}
