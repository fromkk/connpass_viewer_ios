//
//  FooterView.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/17.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class FooterView: UIView
{
    @IBOutlet public var activityIndicator: UIActivityIndicatorView!
}

extension FooterView: InstantiableXIB
{
    @nonobjc public static var xibFilename: String? {
        return "FooterView"
    }
    @nonobjc public static var xibBundle: NSBundle?
}
