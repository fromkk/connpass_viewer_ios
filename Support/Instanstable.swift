//
//  Instanstable.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public protocol Xibable : class
{
    static var xibFilename: String? { get }
    static var xibBundle: NSBundle? { get }
}

extension Xibable where Self: UIView
{
    public static var instantiableXib: UINib {
        let xibFilename: String = self.xibFilename ?? String(self.dynamicType)
        let xibBundle: NSBundle = self.xibBundle ?? NSBundle.mainBundle()
        return UINib(nibName: xibFilename, bundle: xibBundle)
    }
    
    public static func instantiableView(withOwner owner: AnyObject) -> Self? {
        return instantiableXib.instantiateWithOwner(owner, options: nil).first as? Self
    }
}

public protocol Storyboardable : class
{
    static var storyboardFilename: String? { get }
    static var storyboardIdentifier: String? { get }
    static var storyboardBundle: NSBundle? { get }
}

extension Storyboardable where Self: UIViewController
{
    static var instantiableViewController: Self? {
        let name: String = storyboardFilename ?? String(Self)
        let identifier: String = storyboardIdentifier ?? String(Self)
        let bundle: NSBundle = storyboardBundle ?? NSBundle.mainBundle()
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        guard let viewController: Self = storyboard.instantiateViewControllerWithIdentifier(identifier) as? Self else
        {
            return nil
        }
        
        return viewController
    }
}