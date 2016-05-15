//
//  ConnpassManager.swift
//  ConnpassViewer
//
//  Created by Kazuya Ueoka on 2016/05/14.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation
import ObjectMapper

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

public enum ConnpassOrder: Int
{
    case Update = 1
    case Start  = 2
    case Create = 3
}

public enum ConnpassFormat: String
{
    case Json = "json"
}

public protocol ConnpassSearchProtocol
{
    func eventId(eventId: Int) -> Self
    func keyword(keyword: String) -> Self
    func keywordOr(keywordOr: String) -> Self
    func ym(ym: Int) -> Self
    func ymd(ymd: Int) -> Self
    func nickname(nickname: String) -> Self
    func ownerNickname(ownerNickname: String) -> Self
    func seriesId(seriesId: Int) -> Self
    func start(start: Int) -> Self
    func order(order: ConnpassOrder) -> Self
    func count(count: Int) -> Self
    func format(format: ConnpassFormat) -> Self
}

public class ConnpassSearch
{
    private let domain :String = "http://connpass.com"
    private let path: String = "/api/v1/event/"
    private var queries: [String:Querable] = ["count":50, "order": ConnpassOrder.Start.rawValue]
    public var queryString: String {
        let queries: [String] = self.queries.keys.map {
            "\($0.queryValue)=\(self.queries[$0]?.queryValue ?? "")"
        }
        return queries.joinWithSeparator("&")
    }
    public var absoluteString: String {
        return "\(self.domain)\(self.path)?\(self.queryString)"
    }
    public var url: NSURL? {
        print(self.absoluteString)
        return NSURL(string: self.absoluteString)
    }
}

extension ConnpassSearch: ConnpassSearchProtocol
{
    public func eventId(eventId: Int) -> Self {
        self.queries["event_id"] = eventId
        return self
    }
    
    public func keyword(keyword: String) -> Self {
        self.queries["keyword"] = keyword
        return self
    }
    
    public func keywordOr(keywordOr: String) -> Self {
        self.queries["keyword_or"] = keywordOr
        return self
    }
    
    public func ym(ym: Int) -> Self {
        self.queries["ym"] = ym
        return self
    }
    
    public func ymd(ymd: Int) -> Self {
        self.queries["ymd"] = ymd
        return self
    }
    
    public func nickname(nickname: String) -> Self {
        self.queries["nickname"] = nickname
        return self
    }
    
    public func ownerNickname(ownerNickname: String) -> Self {
        self.queries["owner_nickname"] = ownerNickname
        return self
    }
    
    public func seriesId(seriesId: Int) -> Self {
        self.queries["series_id"] = seriesId
        return self
    }
    
    public func start(start: Int) -> Self {
        self.queries["start"] = start
        return self
    }
    
    public func order(order: ConnpassOrder) -> Self {
        self.queries["order"] = order.rawValue
        return self
    }
    
    public func count(count: Int) -> Self {
        self.queries["count"] = count
        return self
    }
    
    public func format(format: ConnpassFormat) -> Self {
        self.queries["format"] = format.rawValue
        return self
    }
}

public struct ConnpassResponse: Mappable
{
    var start: Int = 0
    var returned: Int = 0
    var available: Int = 0
    var events: [ConnpassEvent] = []
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        returned <- map["results_returned"]
        available <- map["results_available"]
        start <- map["results_start"]
        events <- map["events"]
    }
}

public enum ConnpassEventType: String
{
    case Participation = "participation"
    case Advertisement = "advertisement"
}

public struct ConnpassEvent: Mappable
{
    var eventId: Int = 0
    var title: String = ""
    var catchCopy: String = ""
    var description: String = ""
    var eventUrl: String = ""
    var hashTag: String = ""
    var startedAt: String = ""
    var endedAt: String = ""
    var limit:Int = 0
    var eventType: String = ""
    var series: [String:AnyObject] = [:]
    var address: String = ""
    var place: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var ownerId: Int = 0
    var ownerNickname: String = ""
    var ownerDisplayName: String = ""
    var accepted: Int = 0
    var waiting: Int = 0
    var updatedAt: String = ""
    
    public init?(_ map: Map) {}
    public mutating func mapping(map: Map) {
        eventId <- map["event_id"]
        title <- map["title"]
        catchCopy <- map["catch"]
        description <- map["description"]
        eventUrl <- map["event_url"]
        hashTag <- map["hash_tag"]
        startedAt <- map["started_at"]
        endedAt <- map["ended_at"]
        limit <- map["limit"]
        eventType <- map["event_type"]
        series <- map["series"]
        address <- map["address"]
        place <- map["place"]
        lat <- map["lat"]
        lon <- map["lon"]
        ownerId <- map["owner_id"]
        ownerNickname <- map["owner_nickname"]
        ownerDisplayName <- map["owner_display_name"]
        accepted <- map["accepted"]
        waiting <- map["waiting"]
        updatedAt <- map["updated_at"]
    }
}