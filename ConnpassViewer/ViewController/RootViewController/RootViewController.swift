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
import RealmSwift

public final class RootViewController: UIViewController
{
    private lazy var nendView: NADView = {
        let result: NADView = NADView(isAdjustAdSize: true)
        result.nendApiKey = NendConfig.ApiKey.rawValue
        result.nendSpotID = NendConfig.SpotID.rawValue
        result.isOutputLog = true
        result.delegate = self
        result.load()
        return result
    }()
    private lazy var mainViewController: MainViewController = {
        guard let result: MainViewController = MainViewController.instantiableViewController else
        {
            fatalError("mainViewController initialize failed")
        }
        return result
    }()
}

extension RootViewController
{
    public override func loadView() {
        super.loadView()
        
        self.addChildViewController(self.mainViewController)
        self.view.addSubview(self.mainViewController.view)
        self.mainViewController.didMoveToParentViewController(self)
        self.view.addSubview(self.nendView)
    }
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nendView.resume()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.nendView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - self.nendView.frame.size.height, width: self.view.frame.size.width, height: self.nendView.frame.size.height)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.nendView.pause()
    }
}

extension RootViewController: NADViewDelegate
{
    public func nadViewDidReceiveAd(adView: NADView!) {
        print(#function)
        self.mainViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.nendView.frame.size.height)
        self.nendView.hidden = false
    }
    
    public func nadViewDidFailToReceiveAd(adView: NADView!) {
        print(#function)
        self.mainViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.nendView.hidden = true
    }
}

public final class MainViewController: UITableViewController {

    let connpass: ConnpassSearch = ConnpassSearch()
    var request: Request?
    var event: ConnpassResponse?
    var showSearch: Bool = false
    var keyword: String = ""
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
    private lazy var calendarButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_calendar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.onCalendarButtonDidTapped(_:)))
        return result
    }()
    private lazy var headerView: HeaderView? = {
        let result: HeaderView? = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderView.headerIdentifier) as? HeaderView
        result?.closeButton.addTarget(self, action: #selector(self.onCloseButtonDidTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return result
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
        
        self.navigationController?.navigationBar.tintColor = ConnpassColor.themeColor
        self.navigationItem.titleView = self.logoImageView
        self.navigationItem.leftBarButtonItem = self.leftNavigationItem
        self.navigationItem.rightBarButtonItems = [
            self.searchButton,
            self.calendarButton
        ]
        
        self.tableView.addSubview(self.refresher)
        if let nib: UINib = ConnpassEventListCell.instantiableXib
        {
            self.tableView.registerNib(nib, forCellReuseIdentifier: ConnpassEventListCell.cellIdentifier)
        }
        if let nib: UINib = HeaderView.instantiableXib
        {
            self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: HeaderView.headerIdentifier)
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
    
    public override var navigationItem: UINavigationItem {
        guard let navigationItem: UINavigationItem = self.parentViewController?.navigationItem else
        {
            fatalError("navigationItem get failed")
        }
        return navigationItem
    }
    
    public override var navigationController: UINavigationController? {
        return self.parentViewController?.navigationController
    }
}

private protocol MainViewControllerEvents
{
    func onSearchButtonDidTapped(button: UIBarButtonItem?) -> Void
    func onCloseButtonDidTapped(button: UIButton) -> Void
    func onCalendarButtonDidTapped(button: UIButton) -> Void
}

extension MainViewController: MainViewControllerEvents
{
    @objc private func onSearchButtonDidTapped(button: UIBarButtonItem?) {
        let searchViewController: SearchViewController = SearchViewController(style: UITableViewStyle.Plain)
        let navigationController: UINavigationController = UINavigationController(rootViewController: searchViewController)
        searchViewController.delegate = self
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        navigationController.modalPresentationStyle = UIModalPresentationStyle.Custom
        self.presentViewController(navigationController
            , animated: true, completion: nil)
    }
    
    @objc private func onCalendarButtonDidTapped(button: UIButton) {
        let calendarViewController: CalendarViewController = CalendarViewController()
        let navigationController: UINavigationController = UINavigationController(rootViewController: calendarViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @objc private func onCloseButtonDidTapped(button: UIButton) {
        self.keyword = ""
        self.connpass.keyword("")
        self.refresh(nil)
    }
}

extension MainViewController: SearchViewControllerDelegate
{
    public func searchViewController(viewController: SearchViewController, searchExecute search: String?) {
        guard let searchText: String = search?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else
        {
            return
        }
        
        guard 0 != searchText.characters.count else
        {
            return
        }
        
        self.event = nil
        self.tableView.reloadData()
        self.keyword = searchText
        self.connpass.keyword(searchText)
            .start(0)
        self.refresh(nil)
        
        if let latest: History = History.latest
        {
            if latest.word == searchText
            {
                return
            }
        }
        
        let realm: Realm = Realm.sharedRealm()
        do {
            let history :History = History()
            history.word = searchText
            try realm.write({
                realm.add(history)
            })
        } catch
        {
            fatalError("History write failed")
        }
    }
}

extension MainViewController: ConnpassEventListCellDelegate
{
    public func eventListCellLocationButtonDidTapped(event: ConnpassEvent?) {
        guard let mapViewController: MapViewController = MapViewController.instantiableViewController else
        {
            return
        }
        
        mapViewController.event = event
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

extension MainViewController
{
    func refresh(refreshControl: UIRefreshControl?) -> Void
    {
        self.event = nil
        self.tableView.reloadData()
        self.connpass.start(0)
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

extension MainViewController
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
        cell.delegate = self
        
        return cell
    }
}

extension MainViewController
{
    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let keyboard: String = self.keyword where 0 < keyword.characters.count
        {
            if let headerView: HeaderView = self.headerView
            {
                headerView.closeButton.setTitle(keyboard, forState: UIControlState.Normal)
                return headerView
            } else
            {
                return nil
            }
        } else
        {
            return nil
        }
    }
    
    public override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _: String = self.keyword where 0 < keyword.characters.count
        {
            return 48.0
        } else
        {
            return 0.0
        }
    }
    
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
                let safariViewController: SFSafariViewController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                self.navigationController?.pushViewController(safariViewController, animated: true)
            } else
            {
                let browserViewController :BrowserViewController = BrowserViewController(url: url)
                self.navigationController?.pushViewController(browserViewController, animated: true)
            }
        }
    }
}

extension MainViewController
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

extension MainViewController: InstantiableStoryboard
{
    @nonobjc public static var storyboardFilename: String? {
        return "Main"
    }
    
    @nonobjc public static var storyboardBundle: NSBundle?
    @nonobjc public static var storyboardIdentifier: String? {
        return "mainViewController"
    }
}
