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
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        geoFire.setLocation(locationManager.location, forKey: "\( Auth.auth().currentUser!.uid))")
        centerMapOnLocation(location: locationManager.location!)
        print(locationManager.location!)
    }
    
    
    override func viewDidAppear (_ animated: Bool){
        locationAuthStatus()
        
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            centerMapOnLocation(location: locationManager.location!)
        } else{
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation = true
            centerMapOnLocation(location: locationManager.location!)
            
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
    
    
    
   /*
    func createSighting(forLocation location: CLLocation, withUser userId: Int){
        geoFire.setLocation(location, forKey: "\(userId)")
    }
    */
    
    
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     var annotationView: MKAnnotationView?
     let annoIdentifier = "Reader"
        
     if annotation.isKind(of: MKUserLocation.self){
     annotationView=MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
     annotationView?.image = UIImage(named: "pin")
     }
     else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier){
        annotationView = deqAnno
        annotationView?.annotation = annotation
        }
     else {
        let av = MKAnnotationView(annotation:annotation, reuseIdentifier: annoIdentifier)
        av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? ReaderAnnotation{
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "pin")
        //let btn = UIButton()
          //  btn.frame = CGRect(x:0, y:0, width: 30, height:30)
            //btn.setImage(UIImage, for: <#T##UIControlState#>)
        }
        
     return annotationView
     
     }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showReadersOnMap(location: loc)
    }
    
    func showReadersOnMap(location: CLLocation){
    let circleQuery = geoFire!.query(at: location, withRadius: 2000.5)
        _ = circleQuery?.observe(GFEventType.keyEntered, with: {(key, location) in
            if let key = key, let location = location {
                let anno = ReaderAnnotation(coordinate: location.coordinate, readerId: key)
                self.mapView.addAnnotation(anno)
            }
        
        })
    }
    
    
}
