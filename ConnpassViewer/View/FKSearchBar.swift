//
//  FKSearchBar.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/21.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public class FKSearchBar: UISearchBar, Once
{
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self._fkSearchBarCommonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._fkSearchBarCommonInit()
    }
    
    private func _fkSearchBarCommonInit() -> Void
    {
        self.once { 
            self.inputAccessoryView = self.toolBar
        }
    }
    
    private lazy var toolBar: UIToolbar = {
        let result: UIToolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.size.width, height: 44.0)))
        result.items = [self.flexibleSpacer, self.completionButton]
        return result
    }()
    
    private lazy var completionButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("completion", comment: "完了"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.onCompletionButtonDidTapped(_:)))
        return result
    }()
    
    private lazy var flexibleSpacer: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        return result
    }()
}

private protocol FKSearchBarEvents
{
    func onCompletionButtonDidTapped(button: UIBarButtonItem) -> Void
}

extension FKSearchBar: FKSearchBarEvents
{
    @objc private func onCompletionButtonDidTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
