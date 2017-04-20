//
//  RequestDeliveryViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 4/20/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import MapKit

import Firebase
import CoreLocation

class RequestDeliveryViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UITextView!
    
    @IBOutlet var pickupLabel: UILabel!
    
    @IBOutlet var dropoffLabel: UILabel!
    
    @IBOutlet var urgentButton: UIButton!
    @IBAction func urgentPressed(_ sender: Any) {
        disableButtons();
        urgentButton.isSelected = true;
    }
    
    @IBOutlet var todayButton: UIButton!
    @IBAction func todayPressed(_ sender: Any) {
        disableButtons();
        todayButton.isSelected = true;

    }
    
    @IBOutlet var thisWeekButton: UIButton!
    @IBAction func thisWeekPressed(_ sender: Any) {
        disableButtons();
        thisWeekButton.isSelected = true;
    }

    @IBOutlet var ammountLabel: CurrencyField!
    
    @IBAction func confirmPressed(_ sender: Any) {
        if( descriptionLabel.text == ""){
            showErrorMessage(message:"Please enter a description");
        } else if( pickupLabel.text == ""){
            showErrorMessage(message: "Please choose a pickup address.");
        } else if( dropoffLabel.text == ""){
            showErrorMessage(message: "Please choose a drop off address.");
        } else if( urgentButton.isSelected == false && todayButton.isSelected == false && thisWeekButton.isSelected == false){
            showErrorMessage(message: "Please choose an urgency.");
        } else if (ammountLabel.amount == 0.00){
            showErrorMessage(message: "Must select an ammount.");
        } else {
            requestTask();
        }
    }
    
    func requestTask(){
        var urgency = 0;
        if( urgentButton.isSelected == true){
            urgency = 1;
        } else if (todayButton.isSelected == true){
            urgency = 2;
        } else if(thisWeekButton.isSelected == true){
            urgency = 3;
        } else {
            showErrorMessage(message: "Error with urgency.");
            return
        }
        let ref = FIRDatabase.database().reference()
        
      // (TODO)  var midDistance = averageDistances( distanceOne: distanceOne, distanceTwo: distanceTwo)
        
        let newTask = [
            "id" : UserInfoLocal.userID,
//            "midDistance": (TODO),
//            "pickup" : (TODO),
//            "dropOff" : (TODO),
            "description" : descriptionLabel.text,
            "bounty" : ammountLabel.amount,
            "started" : false,
            "urgency" : urgency
            ] as [String : Any]
        

        ref.child("tasks").child("delivery").child(UserInfoLocal.userID).setValue(newTask)
        
    
        let url = "https://venmo.com/?txn=pay&audience=public&recipients=pietro-sette&amount=" + String(format:"%.2f", ammountLabel.amount) + "&note=Paying for " + descriptionLabel.text
        let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = URL(string: escapedString!)!
        UIApplication.shared.open(request)
        
        let alert = UIAlertController(title: "", message: "Task confirmed.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)


    }
    
    func disableButtons(){
        urgentButton.isSelected = false;
        todayButton.isSelected = false;
        thisWeekButton.isSelected = false;
        
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
