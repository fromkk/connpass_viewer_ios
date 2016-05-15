//
//  SearchView.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class SearchView: UIView, InstantiableXIB
{
    public static var xibFilename: String? {
        return "SearchView"
    }
    public static var xibBundle: NSBundle?
    @IBOutlet public weak var searchTextField: UITextField!
    @IBOutlet public weak var searchButton: UIButton!
}

extension SearchView
{
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.searchButton.layer.cornerRadius = 4.0
    }
}

extension SearchView
{
    public typealias SearchViewAnimationCompleteion = () -> Void
    public func show(completion: SearchViewAnimationCompleteion? = nil)
    {
        self.alpha = 0.0
        UIView.animateWithDuration(0.33, animations: {[weak self] in
            self?.alpha = 1.0
        }) { (finished) in
            if finished
            {
                completion?()
            }
        }
    }
    
    public func hide(completion: SearchViewAnimationCompleteion? = nil)
    {
        self.alpha = 1.0
        UIView.animateWithDuration(0.33, animations: {[weak self] in
            self?.alpha = 0.0
        }) { (finished) in
            if finished
            {
                completion?()
            }
        }
    }
}
