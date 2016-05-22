//
//  FKBorderButton.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

@IBDesignable public class FKBorderButton: UIButton
{
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
        }
    }
    
    @IBInspectable public var corerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.corerRadius
        }
    }
}
