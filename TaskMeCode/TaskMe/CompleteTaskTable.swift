//
//  CompleteTaskTable.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/21/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//


import UIKit
import Firebase
import CoreLocation
import FirebaseCore

var categoryTitles: [String] { return["Category1", "Category2", "Category3", "Category4", "Category5", "Category6"]  }

class CompleteTaskTable: UITableViewController , CLLocationManagerDelegate {
    @IBOutlet var myTableView: UITableView!
    var currentPlace = 0
    
    struct nearbyTask{
        var id = ""
        var bounty = 0.0
        var category = ""
        
        var description = ""
        var distanceAway = 0.0
        var latitude = 0.0
        var longitude = 0.0
        
        var started = false
    }
    var nearbyTasks : [nearbyTask] = []
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = nearbyTasks.count
        
        if(count == 0){
            
            return 1
            
        }
        else if(count > 5){
            
            return 5
            
        }
        else{
            return count
        }
    }
    
    func makeCellContent(section: Int)-> customCell{
        
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "FeedCell") as! customCell
        
        if(nearbyTasks.count == 0 ){
            
            cell.ammountLabel.text = ""
            cell.cellLabel.text = "Waiting for tasks"
            
        } else if( currentPlace >= nearbyTasks.count){
            
            if(cell.cellLabel.text == "Label"){
                cell.ammountLabel.text = ""
                cell.cellLabel.text = "Waiting for tasks"
            }
            
            return cell
            
        } else if( section == -1){
            
            cell.ammountLabel.text = ""
            cell.cellLabel.text = "Waiting for tasks"

        } else{

            if(categoryTitles[section] == nearbyTasks[currentPlace].category){
                
                let ammount:String = String(format:"%.2f", nearbyTasks[currentPlace].bounty)
                cell.ammountLabel.text = "$" + ammount
                cell.cellLabel.text = nearbyTasks[currentPlace].description
                print(cell.cellLabel.text!)
                currentPlace += 1

                
            } else {
                
                cell.ammountLabel.text = ""
                cell.cellLabel.text = "Waiting for tasks"

            }
        }
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> customCell {
        
        switch indexPath.section{
        case 0:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 0)
            
        case 1:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 1)
            
        case 2:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 2)
            
        case 3:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 3)
            
        case 4:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 4)
            
        case 5:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: 5)
            
        default:
            print("Section" + String(indexPath.section))
            return makeCellContent(section: -1)
       
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryTitles[section]
    }
    
    
    let locationManager = CLLocationManager()
    
  //  @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        
        loadTasks()
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
       //     menuButton.target = self.revealViewController()
         //   menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func isInRange(result: [String: Any]) -> Bool{
        
        let lat = result["latitude"]
        let long = result["longitude"]
        
        let coordinateTask = CLLocation(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
        
        let distance = locationManager.location?.distance(from: coordinateTask)
        
        
        if(distance! > UserInfoLocal.radius){
            
            return false
            
        }
        var taskToBeAdded = nearbyTask()
        
        taskToBeAdded.bounty = result["bounty"] as! Double
        taskToBeAdded.category = result["category"] as! String
        taskToBeAdded.description = result["description"] as! String
        taskToBeAdded.latitude = result["latitude"] as! Double
        taskToBeAdded.longitude = result["longitude"] as! Double
        
        if(result["started"] != nil){
            
            taskToBeAdded.started = result["started"] as! Bool
        
        }
        
        taskToBeAdded.distanceAway = distance!
        taskToBeAdded.id = result["id"] as! String
        
        nearbyTasks.append(taskToBeAdded)
        
        print("Added Task")
        
        return true
    }
    
    func loadTasks(){
        
        let ref = FIRDatabase.database().reference().child("tasks")
        
        var keys = [String]()
        
        var i = 0
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            for key in ((snapshot.value as AnyObject).allKeys)!{
                
                keys.append(key as! String)
                
            }
            
            let key = keys[i]
            
            i += 1

            if(self.isInRange(result: value?.value(forKey: key) as! [String : Any])){
                self.myTableView.reloadData()
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    

}
