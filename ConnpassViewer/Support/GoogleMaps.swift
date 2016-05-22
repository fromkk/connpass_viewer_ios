//
//  GoogleMaps.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

private struct GoogleMapsKey
{
    let ApiKey :String = "AIzaSyB6Vk3M-UCkzlxqyF8pGG4sdmWgOBKCoH8"
}

private enum GoogleMapsApi: String
{
    case Geocoding = "https://maps.googleapis.com/maps/api/geocode/json"
}

public class GoogleMapsGeocoding
{
    private var queries: [String:Querable] = [:]
    func address(address: Querable) -> GoogleMapsGeocoding {
        self.queries["address"] = address
        return self
    }
    func language(language: Querable) -> GoogleMapsGeocoding {
        self.queries["language"] = language
        return self
    }
    func components(components: Querable) -> GoogleMapsGeocoding
    {
        self.queries["components"] = components
        return self
    }
    public var queryString: String {
        let queries: [String] = self.queries.keys.map {
            "\($0.queryValue)=\(self.queries[$0]?.queryValue ?? "")"
        }
        return queries.joinWithSeparator("&")
    }
    public var absoluteString: String {
        return "\(GoogleMapsApi.Geocoding.rawValue)?\(self.queryString)"
    }
    public var url: NSURL? {
        return NSURL(string: self.absoluteString)
    }
}

public struct GoogleMapsResults
{
    public var results: [GoogleMapsResult]
    public init?(dictionary: [String:AnyObject]?)
    {
        guard let status: String = dictionary?["status"] as? String where status == "OK" else
        {
            return nil
        }
        
        guard let results: [[String:AnyObject]] = dictionary?["results"] as? [[String:AnyObject]]else
        {
            return nil
        }
        
        self.results = results.flatMap {
            GoogleMapsResult(dictionary: $0)
        }
    }
}

public struct GoogleMapsResult
{
    public var addressComponents: [GoogleMapsAddressComponent]
    public var formattedAddress: String
    public var geometry: GoogleMapsGeometry
    public var placeId: String
    public var types: [String]
    
    public init?(dictionary: [String:AnyObject])
    {
        guard let addressComponents: [[String:AnyObject]] = dictionary["address_components"] as? [[String:AnyObject]] else
        {
            return nil
        }
        self.addressComponents = addressComponents.flatMap {
            GoogleMapsAddressComponent(dictionary: $0)
        }
        guard let formattedAddress: String = dictionary["formatted_address"] as? String,
            tmp: [String:AnyObject] = dictionary["geometry"] as? [String:AnyObject],
            geometry: GoogleMapsGeometry = GoogleMapsGeometry(dictionary: tmp),
            placeId: String = dictionary["place_id"] as? String,
            types: [String] = dictionary["types"] as? [String]
            else
        {
            return nil
        }
        self.formattedAddress = formattedAddress
        self.geometry = geometry
        self.placeId = placeId
        self.types = types
    }
}

public struct GoogleMapsAddressComponent
{
    public var longName: String
    public var shortName: String
    public var types: [String]
    public init?(dictionary: [String:AnyObject]?)
    {
        guard let longName: String = dictionary?["long_name"] as? String,
        shortName: String = dictionary?["short_name"] as? String,
        types: [String] = dictionary?["types"] as? [String]
        else
        {
            return nil
        }
        self.longName = longName
        self.shortName = shortName
        self.types = types
    }
}

public struct GoogleMapsGeometry
{
    public var location: GoogleMapsLocation
    public var locationType: String
    public var viewport: [String:GoogleMapsLocation]
    public init?(dictionary: [String:AnyObject]?)
    {
        guard let location: GoogleMapsLocation = GoogleMapsLocation(dictionary: dictionary?["location"] as? [String:AnyObject])
        , locationType: String = dictionary?["location_type"] as? String
        , viewport: [String:AnyObject] = dictionary?["viewport"] as? [String:AnyObject]
        , northeast: GoogleMapsLocation = GoogleMapsLocation(dictionary: viewport["northeast"] as? [String:AnyObject])
        , southwest: GoogleMapsLocation = GoogleMapsLocation(dictionary: viewport["southwest"] as? [String:AnyObject])
         else
        {
            return nil
        }
        self.location = location
        self.locationType = locationType
        self.viewport = [:]
        self.viewport["northeast"] = northeast
        self.viewport["southwest"] = southwest
    }
}

public struct GoogleMapsLocation
{
    public var lat: Double
    public var lng: Double
    public init?(dictionary: [String:AnyObject]?)
    {
        guard let lat: Double = dictionary?["lat"] as? Double,
            lng: Double = dictionary?["lng"] as? Double else
        {
            return nil
        }
        self.lat = lat
        self.lng = lng
    }
}