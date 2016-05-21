//
//  ConnpassEventListCell.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public final class ConnpassEventListCell: UITableViewCell, InstantiableXIB
{
    public static let cellIdentifier: String = "ConnpassEventListCell"
    public static var xibFilename: String? {
        return "ConnpassEventListCell"
    }
    public static var xibBundle: NSBundle?
    
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var borderView: UIView!
    @IBOutlet public weak var locationButton: UIButton!
    @IBOutlet public weak var addressLabel: UILabel!
    @IBOutlet public weak var addressLabelMarginBottomConstraint: NSLayoutConstraint!
    public var event: ConnpassEvent? {
        didSet {
            guard let event = event else
            {
                self.titleLabel.text = nil
                self.dateLabel.text = nil
                self.addressLabel.text = nil
                self.locationButton.hidden = true
                self.addressLabelMarginBottomConstraint.constant = 0
                return
            }
            
            self.titleLabel.text = event.title
            self.dateLabel.text = event.startedDate()?.stringWithFormat("yyyy/MM/dd HH:mm")
            if let address: String = event.address where 0 < address.characters.count {
                self.locationButton.hidden = false
                self.addressLabel.text = address
                self.borderView.hidden = false
                self.addressLabelMarginBottomConstraint.constant = 6
            } else
            {
                self.locationButton.hidden = true
                self.addressLabel.text = nil
                self.borderView.hidden = true
                self.addressLabelMarginBottomConstraint.constant = 0
            }
        }
    }
    
    @IBAction public func onLocationButtonDidTapped(button: UIButton) {
        print(self.event?.address, self.event?.lat, self.event?.lon)
    }
}

extension ConnpassEventListCell
{
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        self.bgView.layer.cornerRadius = 3.0
        self.bgView.layer.shadowColor = UIColor.blackColor().CGColor
        self.bgView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.bgView.layer.shadowRadius = 0.0
        self.bgView.layer.shadowOpacity = 0.1
    }
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
