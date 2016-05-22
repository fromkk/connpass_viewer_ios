//
//  LocationButton.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public class LocationButton: UIButton
{
    var pointInsets: UIEdgeInsets = UIEdgeInsets(top: -10.0, left: -10.0, bottom: -10.0, right: -10.0)
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let bounds: CGRect = UIEdgeInsetsInsetRect(self.bounds, self.pointInsets)
        return bounds.contains(point)
    }
}
