//
//  HeaderView.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public class HeaderView: UITableViewHeaderFooterView
{
    public static let headerIdentifier: String = "HeaderView"
    @IBOutlet public weak var closeButton: FKBorderButton!
}

extension HeaderView: InstantiableXIB
{
    @nonobjc public static var xibFilename: String? {
        return "HeaderView"
    }
    @nonobjc public static var xibBundle: NSBundle?
}
