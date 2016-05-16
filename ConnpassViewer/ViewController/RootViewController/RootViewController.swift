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
    var showSearch: Bool = false
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
    private lazy var searchButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.onSearchButtonDidTapped(_:)))
        return result
    }()
    private lazy var searchView: SearchView = {
        do
        {
            let searchView: SearchView = try SearchView.instantiableView(withOwner: self)
            searchView.searchTextField.delegate = self
            searchView.searchButton.addTarget(self, action: #selector(self.onSearchExecuteButtonDidTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return searchView
        } catch
        {
            fatalError("SearchView initializa failed")
        }
    }()
    private lazy var footerView: FooterView = {
        do
        {
            let result: FooterView = try FooterView.instantiableView(withOwner: self)
            return result
        } catch
        {
            fatalError("FooterView initializa failed")
        }
    }()
    
    public override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
        self.navigationItem.titleView = self.logoImageView
        self.navigationItem.leftBarButtonItem = self.leftNavigationItem
        self.navigationItem.rightBarButtonItem = self.searchButton
        
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
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.searchView.frame = self.view.bounds
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private protocol RootViewControllerEvents
{
    func onSearchButtonDidTapped(button: UIBarButtonItem?) -> Void
    func onSearchExecuteButtonDidTapped(button: UIButton?) -> Void
}

extension RootViewController: RootViewControllerEvents
{
    @objc private func onSearchButtonDidTapped(button: UIBarButtonItem?) {
        self.showSearch = !self.showSearch
        if false == self.showSearch
        {
            if self.searchView.searchTextField.isFirstResponder()
            {
                self.searchView.searchTextField.resignFirstResponder()
            }
            self.searchView.hide({ 
                if self.view.subviews.contains(self.searchView)
                {
                    self.searchView.removeFromSuperview()
                }
            })
        } else
        {
            if !self.view.subviews.contains(self.searchView)
            {
                self.view.addSubview(self.searchView)
            }
            self.searchView.searchTextField.text = nil
            self.searchView.show({ [weak self] in
                self?.searchView.searchTextField.becomeFirstResponder()
            })
        }
    }
    
    @objc private func onSearchExecuteButtonDidTapped(button: UIButton?)
    {
        guard let searchText: String = self.searchView.searchTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else
        {
            return
        }
        
        guard 0 != searchText.characters.count else
        {
            return
        }
        
        self.connpass.keyword(searchText)
        .start(0)
        self.refresh(nil)
        self.onSearchButtonDidTapped(nil)
    }
}

extension RootViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.onSearchExecuteButtonDidTapped(nil)
        return true
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
            self?.tableView.scrollRectToVisible(CGRect.zero, animated: true)
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
    
    func showFooterView() -> Void
    {
        let footerView: FooterView = self.footerView
        footerView.activityIndicator.startAnimating()
        footerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 64.0)
        self.tableView.tableFooterView = footerView
    }
    
    func hideFooterView() -> Void
    {
        let footerView: FooterView = self.footerView
        footerView.activityIndicator.stopAnimating()
        self.tableView.tableFooterView = nil
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
            self.hideFooterView()
            return
        }
        
        self.showFooterView()
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