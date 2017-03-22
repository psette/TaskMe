//
//  CompleteTaskViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/21/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseCore



class CompleteTaskViewController: UIViewController, CLLocationManagerDelegate {

    @IBAction func buttonPressed(_ sender: Any) {
        loadTasks()
    }
    
    struct nearbyTask{
        var id = ""
        var bounty = 0.0
        var category = ""
        
        var description = ""
        var latitude = 0.0
        var longitude = 0.0
        
        var started = false
    }
    var nearbyTasks : [nearbyTask] = []
    
    let locationManager = CLLocationManager()
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
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
        taskToBeAdded.id = result["id"] as! String
        nearbyTasks.append(taskToBeAdded)
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
                print("Added Task")
            }
                i += 1
            
        }) { (error) in
            print(error.localizedDescription)
        }
        displayTasks()
    }
    
    
    func displayTasks(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
