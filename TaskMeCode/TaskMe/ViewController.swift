//
//  ViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 1/27/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//
import UIKit

struct UserInfoLocal {
    static var FirstName = ""
    static var LastName = ""

    static var userID = ""
    
    static var radius = 80467.2
    static var Email = ""
    static var isAuthenticated = false

    
}
struct deliveryPrefrences {
    
    static var pickupLong = 0.0
    static var pickupLat = 0.0
    
    static var dropoffLong = 0.0
    static var dropoffLat = 0.0
    
}

class ViewController: UIViewController  {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
