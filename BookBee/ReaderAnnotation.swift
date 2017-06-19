//
//  Reader.swift
//  BookBee
//
//  Created by Mac on 6/19/17.
//  Copyright © 2017 Irina Dorofeeva. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MapKit


class ReaderAnnotation : NSObject, MKAnnotation{
var coordinate: CLLocationCoordinate2D
    var readerId:String?
    var title: String?
    var readerName: String
    
    init(coordinate: CLLocationCoordinate2D, readerId: String){
    
    self.coordinate = coordinate
    self.readerId = readerId
    self.readerName = Database.database().reference().child("users").child((readerId)).child("name").key
    self.title = "title"
   //     self.readerName =  Database.database().reference().child("users").child((user?.uid)!).child("name").setValue(self.nameTextField.text)

    }
}
