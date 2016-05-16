//
//  History.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/17.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public final class History: Object
{
    public dynamic var word: String = ""
    public dynamic var createdAt: NSDate = NSDate()
    
    public static var latest: History? {
        return Realm.sharedRealm().objects(History).sorted("createdAt", ascending: false).first
    }
}