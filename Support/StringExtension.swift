//
//  StringExtension.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/14.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

public extension String
{
    func urlEscape() -> String
    {
        let allowedCharacterSet: NSMutableCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        allowedCharacterSet.addCharactersInString("-._~")
        guard let result: String = self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) else
        {
            return ""
        }
        return result
    }
}