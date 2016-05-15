//
//  RootViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/14.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

public final class RootViewController: UITableViewController {

    let connpass: ConnpassSearch = ConnpassSearch()
    var event: ConnpassResponse?
    lazy var logoImageView: UIImageView = {
        let result: UIImageView = UIImageView(image: UIImage(named: "connpass_logo"))
        result.contentMode = UIViewContentMode.ScaleAspectFit
        result.frame = CGRect(x: 0.0, y: 0.0, width: 97.0, height: 33.0)
        return result
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let result: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        return result
    }()
    private lazy var leftNavigationItem: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
        return result
    }()
    
    public override func loadView() {
        super.loadView()
        
        self.navigationItem.titleView = self.logoImageView
        self.navigationItem.leftBarButtonItem = self.leftNavigationItem
        
        if let nib: UINib = ConnpassEventListCell.instantiableXib
        {
            self.tableView.registerNib(nib, forCellReuseIdentifier: ConnpassEventListCell.cellIdentifier)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        ConnpassResponse.fetch(self.connpass, completion: { [weak self] (response) in
            self?.activityIndicator.stopAnimating()
            self?.event = response
            self?.tableView.reloadData()
        }) { [weak self] (error) in
            self?.activityIndicator.stopAnimating()
            guard let strongSelf = self else
            {
                return
            }
            let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("error", comment: "error"), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            strongSelf.presentViewController(alertController, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RootViewController
{
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.event?.events.count ?? 0
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ConnpassEventListCell = tableView.dequeueReusableEventListCell(forIndexPath: indexPath)
        
        if self.event?.events.count ?? 0 > indexPath.row
        , let event: ConnpassEvent = self.event?.events[indexPath.row]
        {
            cell.titleLabel.text = event.title
            cell.dateLabel.text = event.startedAt
        }
        
        return cell
    }
}

extension RootViewController
{
    public override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}