//
//  Instanstable.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

enum InstantiableError: ErrorType
{
    case InstantiableFailure
}

public protocol InstantiableXIB : class
{
    static var xibFilename: String? { get }
    static var xibBundle: NSBundle? { get }
}

extension InstantiableXIB where Self: UIView
{
    public static var instantiableXib: UINib {
        let xibFilename: String = self.xibFilename ?? String(self.dynamicType)
        let xibBundle: NSBundle = self.xibBundle ?? NSBundle.mainBundle()
        return UINib(nibName: xibFilename, bundle: xibBundle)
    }
    
    public static func instantiableView(withOwner owner: AnyObject) throws -> Self {
        guard let result: Self = instantiableXib.instantiateWithOwner(owner, options: nil).first as? Self else
        {
            throw InstantiableError.InstantiableFailure
        }
        
        return result
    }
}

public protocol InstantiableStoryboard : class
{
    static var storyboardFilename: String? { get }
    static var storyboardIdentifier: String? { get }
    static var storyboardBundle: NSBundle? { get }
}

extension InstantiableStoryboard where Self: UIViewController
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
