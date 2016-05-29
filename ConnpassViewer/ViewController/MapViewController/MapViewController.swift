//
//  MapViewController.swift
//  ConnpassViewer
//
//  Created by Ueoka Kazuya on 2016/05/22.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

public struct Location
{
    var latitude: Double
    var longitude: Double
}

public final class MapViewController: UIViewController
{
    @IBOutlet public weak var mapView: MKMapView!
    public var event: ConnpassEvent? {
        didSet {
            if let latitude: Double = event?.lat, longitude: Double = event?.lon where 0.0 != latitude && 0 != longitude
            {
                self.location = Location(latitude: latitude, longitude: longitude)
            } else if let address: String = event?.address
            {
                self.address = address
            }
        }
    }
    private var location: Location? {
        didSet {
            guard let location = self.location where self.isViewLoaded() else
            {
                return
            }
            
            self.setLocation(location)
        }
    }
    
    private var address: String? {
        didSet {
            guard let address = self.address else
            {
                return
            }
            
            let googleMapsGeocoding: GoogleMapsGeocoding = GoogleMapsGeocoding()
                .address(address)
                .language((NSLocale.systemLocale().objectForKey(NSLocaleLanguageCode) as? String) ?? "JP")
            Alamofire.request(.GET, googleMapsGeocoding.absoluteString).responseJSON { (response) in
                switch response.result
                {
                case .Success(let value):
                    if let googleMaps: GoogleMapsResults = GoogleMapsResults(dictionary: value as? [String:AnyObject]),
                        result: GoogleMapsResult = googleMaps.results.first,
                        location: GoogleMapsLocation = result.geometry.location
                    {
                        self.location = Location(latitude: location.lat, longitude: location.lng)
                    }
                    break
                case .Failure(let error):
                    print(#function, #line, error)
                    break
                }
            }
        }
    }
}

extension MapViewController
{
    public override func loadView() {
        super.loadView()
        
        guard let location = self.location else
        {
            return
        }
        
        self.setLocation(location)
    }
    
    private func setLocation(location: Location) -> Void
    {
        var region: MKCoordinateRegion = self.mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        let clLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        region.center = clLocation
        self.mapView.region = region
        
        self.mapView.centerCoordinate = clLocation
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = clLocation
        annotation.title = self.event?.title
        annotation.subtitle = self.event?.address
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: InstantiableStoryboard
{
    @nonobjc public static var storyboardFilename: String? {
        return "MapViewController"
    }
    
    @nonobjc public static var storyboardIdentifier: String? {
        return "mapViewController"
    }
    
    @nonobjc public static var storyboardBundle: NSBundle?
}
