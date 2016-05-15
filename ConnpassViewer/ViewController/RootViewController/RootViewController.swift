//
//  RootViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/14.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

public final class RootViewController: UITableViewController {

    let connpass: ConnpassSearch = ConnpassSearch()
    var request: Request?
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
    private lazy var refresher: UIRefreshControl = {
        let refresher: UIRefreshControl = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refresher
    }()
    
    public override func loadView() {
        super.loadView()
        
        self.navigationItem.titleView = self.logoImageView
        self.navigationItem.leftBarButtonItem = self.leftNavigationItem
        
        self.tableView.addSubview(self.refresher)
        if let nib: UINib = ConnpassEventListCell.instantiableXib
        {
            self.tableView.registerNib(nib, forCellReuseIdentifier: ConnpassEventListCell.cellIdentifier)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh(nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RootViewController
{
    func refresh(refreshControl: UIRefreshControl?) -> Void
    {
        self.activityIndicator.startAnimating()
        self.request = ConnpassResponse.fetch(self.connpass, completion: { [weak self] (response) in
            refreshControl?.endRefreshing()
            self?.activityIndicator.stopAnimating()
            self?.event = response
            self?.tableView.reloadData()
            self?.request = nil
        }) { [weak self] (error) in
            refreshControl?.endRefreshing()
            self?.request = nil
            self?.activityIndicator.stopAnimating()
            self?.showError(error)
        }
    }
    
    func showError(error: NSError?)
    {
        guard let error = error else
        {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("error", comment: "error"), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
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
        cell.event = nil
        if self.event?.events.count ?? 0 > indexPath.row
        , let event: ConnpassEvent = self.event?.events[indexPath.row]
        {
            cell.event = event
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
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.event?.events.count > indexPath.row
            , let event: ConnpassEvent = self.event?.events[indexPath.row]
        {
            print(event)
            guard let url: NSURL = NSURL(string: event.eventUrl) else
            {
                return
            }
            
            if #available(iOS 9, *)
            {
                let safariViewController: SFSafariViewController = SFSafariViewController(URL: url)
                self.navigationController?.pushViewController(safariViewController, animated: true)
            } else
            {
                let browserViewController :BrowserViewController = BrowserViewController(url: url)
                self.navigationController?.pushViewController(browserViewController, animated: true)
            }
        }
    }
}

extension RootViewController
{
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard nil == self.request else
        {
            return
        }
        let min: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
        if min > 200.0
        {
            return
        }
        
        guard self.event?.hasNext() ?? false else
        {
            return
        }
        
        self.activityIndicator.startAnimating()
        self.request = self.event?.next(self.connpass, completion: { [weak self] (response) in
            self?.tableView.reloadData()
            self?.request = nil
            self?.activityIndicator.stopAnimating()
        }, failure: { [weak self] (error) in
            self?.activityIndicator.stopAnimating()
            self?.request = nil
            self?.showError(error)
        })
    }
}