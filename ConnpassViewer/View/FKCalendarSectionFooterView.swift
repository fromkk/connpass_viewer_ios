//
//  FKCalendarSectionFooterView.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/29.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class FKCalendarSelectionFooterView: UICollectionReusableView
{
    public static let viewIdentifier: String = "FKCalendarSelectionFooterView"
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ConnpassColor.lightColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
