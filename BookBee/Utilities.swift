//
//  Utilities.swift
//  BookBee
//
//  Created by Mac on 6/15/17.
//  Copyright © 2017 Irina Dorofeeva. All rights reserved.
//

import Foundation
import UIKit

class Utilities{

    func ShowAlert (title: String, message: String, vc: UIViewController){
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    
    }
}
