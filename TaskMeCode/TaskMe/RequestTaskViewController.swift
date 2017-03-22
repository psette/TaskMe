//
//  RequestTaskViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/21/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class RequestTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()

    @IBOutlet var ammountOffered: CurrencyField!
    @IBOutlet var descriptionField: UITextView!
    
    @IBAction func confirmPressed(_ sender: Any) {
    
        let ref = FIRDatabase.database().reference()
        let indexSelected = picker.selectedRow(inComponent: 0)
        let pickerValue = pickerData[indexSelected]
        let newTask = [
            "id" : UserInfoLocal.userID,
            "latitude" : locationManager.location?.coordinate.latitude ?? -404.00,
            "longitude" : locationManager.location?.coordinate.longitude ?? -404.00,
            "category" : pickerValue,
            "description" : descriptionField.text,
            "bounty" : ammountOffered.amount,
            "started" : false
            ] as [String : Any]
        print("ID")
        print(UserInfoLocal.userID)
        ref.child("tasks").child(UserInfoLocal.userID).setValue(newTask)
        

    }
    
    @IBOutlet var picker: UIPickerView!
    var pickerData: [String] = [String]()

    @IBOutlet var charLeft: UILabel!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["Cat 1", "Cat 2", "Cat 3", "Cat 4", "Cat 5", "Cat 6"]
        // Do any additional setup after loading the view.
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
