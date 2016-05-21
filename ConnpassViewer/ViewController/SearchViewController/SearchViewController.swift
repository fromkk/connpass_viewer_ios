//
//  SearchViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/21.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import RealmSwift

@objc public protocol SearchViewControllerDelegate : class {
    func searchViewController(viewController: SearchViewController, searchExecute search: String?) -> Void
}

public final class SearchViewController: UITableViewController
{
    private lazy var closeButton: UIBarButtonItem = {
        let result: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("close", comment: "閉じる"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.onCloseButtonDidTapped(_:)))
        return result
    }()
    public lazy var searchBar: FKSearchBar = {
        let result: FKSearchBar = FKSearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 48.0))
        result.delegate = self
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private lazy var histories: Results <History> = {
        let realm: Realm = Realm.sharedRealm()
        return realm.objects(History).sorted("createdAt", ascending: false)
    }()
    public weak var delegate: SearchViewControllerDelegate?
}

extension SearchViewController
{
    public override func loadView() {
        super.loadView()
        
        self.tableView.registerClass(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.cellIdentifier)
        self.navigationItem.leftBarButtonItem = self.closeButton
        self.tableView.tableHeaderView = self.searchBar
    }
}

extension SearchViewController: UISearchBarDelegate
{
    public func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    public func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true) {[weak self] in
            guard let strongSelf = self else
            {
                return
            }
            strongSelf.delegate?.searchViewController(strongSelf, searchExecute: searchBar.text)
        }
    }
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

private protocol SearchViewControllerEvents
{
    func onCloseButtonDidTapped(button: UIBarButtonItem) -> Void
}

extension SearchViewController: SearchViewControllerEvents
{
    @objc private func onCloseButtonDidTapped(button: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SearchViewController
{
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SearchViewCell = tableView.dequeueReusableSearchViewCell(forIndexPath: indexPath)
        let history: History = self.histories[indexPath.row]
        cell.textLabel?.text = history.word
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) {[weak self] in
            guard let strongSelf = self else
            {
                return
            }
            let history: History = strongSelf.histories[indexPath.row]
            strongSelf.delegate?.searchViewController(strongSelf, searchExecute: history.word)
        }
    }
}
