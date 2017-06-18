//
//  MapViewController.swift
//  BookBee
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Irina Dorofeeva. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
       // mapView.userTrackingMode = MKUserTrackingMode.follow
        
        
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        geoFire.setLocation(locationManager.location, forKey: "\( Auth.auth().currentUser!.uid))")
        centerMapOnLocation(location: locationManager.location!)
        
        /*  if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
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
         }*/
        
    }
    
    
    override func viewDidAppear (_ animated: Bool){
        locationAuthStatus()
        
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200000, 200000)
        
        mapView.setRegion(coordinateRegion, animated:true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        if let loc = userLocation.location {
            if !mapHasCenteredOnce{
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce=true
            }
        }
    }
    
    func createSighting(forLocation location: CLLocation, withUser userId: Int){
    geoFire.setLocation(location, forKey: "\(userId)")
    }
    
    /* func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     var annotationView: MKAnnotationView?
     if annotation.isKind(of: MKUserLocation.self){
     
     annotationView=MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
     annotationView?.image = UIImage(named: "dot")
     
     }
     return annotationView
     
     }
     */
    
    
}
