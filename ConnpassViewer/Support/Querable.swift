//
//  Querable.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

public protocol Querable
{
    var queryValue: String { get }
}

extension Int: Querable
{
    public var queryValue: String {
        return String(self).queryValue
    }
}

extension String: Querable
{
    public var queryValue: String {
        return self.urlEscape()
    }
}