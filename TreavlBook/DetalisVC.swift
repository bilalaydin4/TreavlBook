//
//  DetalisVC.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import MapKit

class DetalisVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    

 

}
