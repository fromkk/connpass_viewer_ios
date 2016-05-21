//
//  BrowserViewController.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/15.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import WebKit

public final class BrowserViewController: UIViewController
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
        result.addObserver(self, forKeyPath: "estimatedProgress", options: [.New], context: nil)
        return result
    }()
    
    public lazy var progressView: UIProgressView = {
        let result: UIProgressView = UIProgressView()
        return result
    }()
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else
        {
            return
        }
        
        if keyPath == "estimatedProgress" && self.webView.isEqual(object)
        {
            self.progressView.progress = Float(self.webView.estimatedProgress)
            self.progressView.hidden = 1.0 == self.progressView.progress
        }
    }
    
    deinit
    {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension BrowserViewController
{
    public override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.webView)
        self.navigationController?.navigationBar.addSubview(self.progressView)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.progressView.frame = CGRect(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height ?? 0.0) - 1.0, width: self.navigationController?.navigationBar.frame.size.width ?? 0.0, height: 1.0)
        self.webView.frame = self.view.bounds
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.progressView.hidden = true
    }
}

extension BrowserViewController: WKNavigationDelegate
{
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.title = webView.title
    }
}
