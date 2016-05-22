//
//  SectionFooterView.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public class SectionFooterView: UITableViewHeaderFooterView, Once
{
    public static let footerIdentifier: String = "SectionFooterView"
    public lazy var nendView: NADView = {
        let result: NADView = NADView(isAdjustAdSize: true)
        result.nendApiKey = NendConfig.ApiKey.rawValue
        result.nendSpotID = NendConfig.SpotID.rawValue
        result.isOutputLog = true
        result.load()
        return result
    }()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.once { 
            self.addSubview(self.nendView)
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.nendView.frame = self.bounds
    }
}
