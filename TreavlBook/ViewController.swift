//
//  ViewController.swift
//  TreavlBook
//
//  Created by Bilal Aydın on 25.01.2025.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var NameArray : [String] = []
    var IdArray : [UUID] = []
    
    var selectedName = ""
    var selectedId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.title = "Travel Book"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getData))
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("deleateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = NameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = IdArray[indexPath.row]
        selectedName = NameArray[indexPath.row]
        performSegue(withIdentifier: "toDetalisVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetalisVC" {
            let destinationVC = segue.destination as! DetalisVC
            destinationVC.chosenId = selectedId
            destinationVC.chosenPlace = selectedName
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let idString = IdArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id == %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == IdArray[indexPath.row] {
                                
                                IdArray.remove(at: indexPath.row)
                                NameArray.remove(at: indexPath.row)
                                context.delete(result)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                    print("Delete Success :)")
                                }catch {
                                    print("Erorrs")
                                }
                            }
                        }
                    }
                }
            }catch {
                print("Erorr")
            }
            
        }
    }
    
    

    @objc func getData(){
        
        NameArray.removeAll(keepingCapacity: false)
        IdArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        IdArray.append(id)
                    }
                    if let name = result.value(forKey: "name") as? String {
                        NameArray.append(name)
                    }
                }
            }
            self.tableView.reloadData()
        }catch {
            print("Error")
        }
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }

}

