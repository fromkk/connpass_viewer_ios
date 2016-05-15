//
//  BrowserViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import WebKit

public final class WebViewController: UIViewController
{
    public var url: NSURL? {
        didSet {
            guard let url: NSURL = self.url else
            {
                return
            }
            self.webView.loadRequest(NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0))
        }
    }
    
    public init(url: NSURL) {
        super.init(nibName: nil, bundle: nil)
        
        defer
        {
            self.url = url
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var webView: WKWebView = {
        let result: WKWebView = WKWebView()
        result.navigationDelegate = self
        return result
    }()
    
    public lazy var progressView: UIProgressView = {
        let result: UIProgressView = UIProgressView()
        result.translatesAutoresizingMaskIntoConstraints = false
        if let navigationController: UINavigationController = self.navigationController
            ,let navigationBar: UINavigationBar = self.navigationController?.navigationBar
        {
            navigationController.view.addConstraints([
                NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: result, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: result, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: result, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
                ])
        }
        return result
    }()
}

extension WebViewController
{
    public override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.webView)
        self.navigationController?.navigationBar.addSubview(self.progressView)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.webView.frame = self.view.bounds
    }
}

extension WebViewController: WKNavigationDelegate
{
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.title = webView.title
    }
}

public final class BrowserViewController: UINavigationController
{
    public init(url: NSURL) {
        super.init(rootViewController: WebViewController(url: url))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}