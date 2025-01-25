//
//  AddVC.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import MapKit
import CoreLocation

class AddVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeCommend: UITextField!
    @IBOutlet weak var coordinateLable: UILabel!
    @IBOutlet weak var wraningLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var localManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        localManager.delegate = self
        localManager.requestWhenInUseAuthorization()
        localManager.desiredAccuracy = kCLLocationAccuracyBest
        localManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.latitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

   

}
