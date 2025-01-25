//
//  AddVC.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import MapKit

class AddVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeCommend: UITextField!
    @IBOutlet weak var coordinateLable: UILabel!
    @IBOutlet weak var wraningLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    

   

}
