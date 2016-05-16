//
//  RealmExtension.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/17.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm
{
    public static func sharedRealm() -> Realm
    {
        do {
            let result: Realm = try Realm()
            return result
        } catch {
            fatalError("Realm get failed")
        }
    }
}