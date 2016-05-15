//
//  ConnpassEventListCell.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class ConnpassEventListCell: UITableViewCell, Xibable
{
    public static let cellIdentifier: String = "ConnpassEventListCell"
    public static var xibFilename: String? {
        return "ConnpassEventListCell"
    }
    public static var xibBundle: NSBundle?
    
    @IBOutlet public var titleLabel: UILabel!
    @IBOutlet public var dateLabel: UILabel!
}

extension UITableView
{
    func dequeueReusableEventListCell(forIndexPath indexPath: NSIndexPath) -> ConnpassEventListCell
    {
        guard let cell: ConnpassEventListCell = self.dequeueReusableCellWithIdentifier(ConnpassEventListCell.cellIdentifier, forIndexPath: indexPath) as? ConnpassEventListCell else
        {
            return ConnpassEventListCell(style: UITableViewCellStyle.Default, reuseIdentifier: ConnpassEventListCell.cellIdentifier)
        }
        return cell
    }
}