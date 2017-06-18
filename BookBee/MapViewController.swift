//
//  MapViewController.swift
//  BookBee
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Irina Dorofeeva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
       if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
       {
        print("ready to go")
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
    
        }
       else{
        
        manager.requestWhenInUseAuthorization()
        print("asked auth")
        mapView.showsUserLocation = true
     
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("We made it!")
        }
        
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
