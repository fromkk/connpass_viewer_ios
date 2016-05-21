//
//  Once.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/21.
//  Copyright © 2016年 fromKK. All rights reserved.
//
import Foundation

public protocol Once : AnyObject {}

private struct OnceAssociateObjectHandle
{
    static var OnceKey :UInt8 = 0
}

private class OnceStack
{
    private init() {}
    private var stacks :[String] = []
    func hasKey(key :String) -> Bool
    {
        return self.stacks.contains(key)
    }
    func addKey(key :String)
    {
        if !self.hasKey(key)
        {
            self.stacks.append(key)
        }
    }
    func clear()
    {
        self.stacks.removeAll()
    }
}

public extension Once where Self :AnyObject
{
    typealias OnceExecution = () -> Void
    func once(key :String = #function, @noescape execution :OnceExecution) -> Void
    {
        let stacks :OnceStack = self.stack
        if !stacks.hasKey(key)
        {
            execution()
            stacks.addKey(key)
        }
    }
    func clearOnce() -> Void
    {
        self.stack.clear()
    }
    
    private var stack :OnceStack {
        guard let result :OnceStack = objc_getAssociatedObject(self, &OnceAssociateObjectHandle.OnceKey) as? OnceStack else
        {
            let result :OnceStack = OnceStack()
            objc_setAssociatedObject(self, &OnceAssociateObjectHandle.OnceKey, result, .OBJC_ASSOCIATION_RETAIN)
            return result
        }
        return result
    }
}