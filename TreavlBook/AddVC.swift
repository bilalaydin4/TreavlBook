//
//  AddVC.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import MapKit
import CoreLocation

class AddVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeComment: UITextField!
    @IBOutlet weak var coordinateLable: UILabel!
    @IBOutlet weak var wraningLabel: UILabel!
    
    var choseImage = false
    var takeLocation = true
    var myLatitude: Double?
    var myLongitude: Double?
    var choosenLatitude: Double?
    var choosenLongitude: Double?
    
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
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizerL = UILongPressGestureRecognizer(target: self, action: #selector(addLocation(gestureRecognizerL:)))
        mapView.addGestureRecognizer(gestureRecognizerL)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if takeLocation == true {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            myLatitude = location.latitude
            myLongitude = location.longitude
            coordinateLable.text = "\(location.latitude) ,\(location.longitude)"
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            takeLocation = false
        }
        
      
    }
    
    @objc func addLocation(gestureRecognizerL: UILongPressGestureRecognizer) {
        
        if gestureRecognizerL.state == .began {
            if placeName.text != "" && placeComment.text != "" && choseImage == true {
                
                let touchPoint = gestureRecognizerL.location(in: mapView)
                let touchedCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                
                choosenLatitude = touchedCoordinate.latitude
                choosenLongitude = touchedCoordinate.longitude
                coordinateLable.text = "\(touchedCoordinate.latitude) ,\(touchedCoordinate.longitude)"
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = touchedCoordinate
                annotation.title = placeName.text
                annotation.subtitle = placeComment.text
                mapView.addAnnotation(annotation)
                
                
            }else {
                alerts(title: "Be Careful", message: "Plase Enter Place name, Place comment and Select Image")
            }
        }
    }
    

   

    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        wraningLabel.textColor = .green
        wraningLabel.text = "Image added"
        choseImage = true
        dismiss(animated: true)
    }
    
    @IBAction func myLocation(_ sender: Any) {
        
        if let latitude = myLatitude, let longitude = myLongitude {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
      
    }
    
    func alerts (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}
