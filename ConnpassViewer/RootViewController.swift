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

public final class RootViewController: UIViewController {

    let connpass: ConnpassSearch = ConnpassSearch()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, self.connpass.absoluteString)
            .responseJSON {[weak self] (response: Response<AnyObject, NSError>) in
                switch response.result
                {
                case .Success(let value):
                    if let event = Mapper<ConnpassResponse>().map(value)
                    {
                        print(event)
                    }
                    break
                case .Failure(let error):
                    let alert: UIAlertController = UIAlertController(title: NSLocalizedString("error", comment: "error"), message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default, handler: nil))
                    self?.presentViewController(alert, animated: true, completion: nil)
                    break
                }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

