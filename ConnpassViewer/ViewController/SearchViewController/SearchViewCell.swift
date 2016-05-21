//
//  SearchViewCell.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/21.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class SearchViewCell: UITableViewCell
{
    public static let cellIdentifier: String = "SearchViewCell"
}

extension UITableView
{
    func dequeueReusableSearchViewCell(forIndexPath indexPath: NSIndexPath) -> SearchViewCell
    {
        guard let cell: SearchViewCell = self.dequeueReusableCellWithIdentifier(SearchViewCell.cellIdentifier, forIndexPath: indexPath) as? SearchViewCell else
        {
            return SearchViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: SearchViewCell.cellIdentifier)
        }
        return cell
    }
}