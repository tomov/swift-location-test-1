//
//  ViewController.swift
//  MotionSurvey1
//
//  Created by memsql on 2/2/16.
//  Copyright © 2016 Princeton. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Instance variables

    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    
    var motionManager = CMMotionManager()
    
    // Outlets
    
    @IBOutlet var accX: UILabel?
    @IBOutlet var accY: UILabel?
    @IBOutlet var accZ: UILabel?
    @IBOutlet var maxAccX: UILabel?
    @IBOutlet var maxAccY: UILabel?
    @IBOutlet var maxAccZ: UILabel?
    
    // Functions
    
    @IBAction func resetMaxValues() {
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
        
        maxAccX?.text = "SHIT"
        maxAccY?.text = "SHIT"
        maxAccZ?.text = "SHIT"
    }
    
    func updateLabels() {
        maxAccX?.text = "\(currentMaxAccelX).2f"
        maxAccY?.text = "\(currentMaxAccelY).2f"
        maxAccZ?.text = "\(currentMaxAccelZ).2f"
    }
    
    let locMgr = CLLocationManager()
    
    override func viewDidLoad() {

        //
        // Accelerometer stuff
        //
        
        self.resetMaxValues()
        
        // Set motion manager properties
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        print("woooot")
        
        // Start recording data
        // TODO UNCOMMENT FOR ACCELEROMETER BADASSERY
        /*
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue())
            { (data: CMAccelerometerData?, error: NSError?) -> Void
            in
            self.outputAccelerationData(data!.acceleration)
            if (error != nil) {
                print("\(error)")
            }
        }
        */
        
        super.viewDidLoad()

        //
        // Location stuff
        //
        
        locMgr.desiredAccuracy = kCLLocationAccuracyBest // TODO really?
        locMgr.requestWhenInUseAuthorization()
        locMgr.startUpdatingLocation()
        locMgr.delegate = self // important
        
    }
    
    
    @IBOutlet weak var myLat: UILabel!
    @IBOutlet weak var myLon: UILabel!
    @IBOutlet weak var myCourse: UILabel!
    @IBOutlet weak var mySpeed: UILabel!
    @IBOutlet weak var myAddress: UILabel!
    
    func outputAccelerationData(acceleration: CMAcceleration) {
        print("accelerate bitch! x = \(acceleration.x) y = \(acceleration.y) z = \(acceleration.z)")
        
        if fabs(acceleration.x) > fabs(currentMaxAccelX) {
            currentMaxAccelX = acceleration.x
        }
        if fabs(acceleration.y) > fabs(currentMaxAccelY) {
            currentMaxAccelY = acceleration.y
        }
        if fabs(acceleration.z) > fabs(currentMaxAccelZ) {
            currentMaxAccelZ = acceleration.z
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.accX?.text = "\(acceleration.x)"
            self.accY?.text = "\(acceleration.y)"
            self.accZ?.text = "\(acceleration.z)"
            
            self.updateLabels()
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myCurrentLoc = locations[locations.count - 1]
        myLat.text = "\(myCurrentLoc.coordinate.latitude)"
        myLon.text = "\(myCurrentLoc.coordinate.longitude)"
        myCourse.text = "\(myCurrentLoc.course)"
        mySpeed.text = "\(myCurrentLoc.speed)"
        
        CLGeocoder().reverseGeocodeLocation(myCurrentLoc) { (myPlacements, error) -> Void in
            if error != nil {
                print("\(error)")
            }
            
            if let myPlacemet = myPlacements?.first
            {
                self.myAddress.text = "\(myPlacemet.locality!) \(myPlacemet.country!) \(myPlacemet.postalCode!)"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

