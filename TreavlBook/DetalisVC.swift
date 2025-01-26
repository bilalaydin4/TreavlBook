//
//  DetalisVC.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import MapKit
import CoreData

class DetalisVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    

    var chosenPlace = ""
    var chosenId : UUID?
    
    var annotationTitle : String?
    var annotationSubtitle : String?
    var annotationLatitude : Double?
    var annotationLongitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePlace))
        
        
        
        if chosenId != nil && chosenPlace != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let idString = chosenId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id == %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "name") as? String {
                            annotationTitle = title
                            
                            if let subTitle = result.value(forKey: "comment") as? String {
                                annotationSubtitle = subTitle
                                
                                if let latitude = result.value(forKey: "latitude") as? Double {
                                    annotationLatitude = latitude
                                    
                                    if let longitude = result.value(forKey: "longitude") as? Double {
                                        annotationLongitude = longitude
                                        
                                        if let imageData = result.value(forKey: "image") as? Data {
                                            imageView.image = UIImage(data: imageData)
                                            self.navigationItem.title = annotationTitle
                                            
                                            let annotation = MKPointAnnotation()
                                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude!, longitude: annotationLongitude!)
                                            annotation.title = annotationTitle
                                            annotation.subtitle = annotationSubtitle
                                            annotation.coordinate = coordinate
                                            mapView.addAnnotation(annotation)
                                            
                                            infoTextView.text = "\(annotationTitle!) , \n\(annotationSubtitle!) \n ---------------- \n latitude:  \(annotationLatitude!) \n longitude: \(annotationLongitude!) "
                                            infoTextView.isEditable = false
                                            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            let region = MKCoordinateRegion(center: coordinate, span: span)
                                            mapView.setRegion(region, animated: true)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }catch {
                print("Error")
            }
        }
    }
    

    @objc func deletePlace () {
        
        let alert = UIAlertController(title: "Deletion Success", message: "Place deleted", preferredStyle: UIAlertController.Style.alert )
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let idString = self.chosenId!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id == %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == self.chosenId {
                                context.delete(result)
                                
                                do {
                                    try context.save()
                                    print("Delete Success :)")
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name("deleateData"), object: nil)
                                    self.navigationController?.popViewController(animated: true)
                                   
                                }catch{
                                    print("Error")
                                }
                            }
                        }
                        
                    }
                    
                }
            }catch {
                print("Error")
            }
            
        }
        alert.addAction(okbutton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
        
       
    }

}
