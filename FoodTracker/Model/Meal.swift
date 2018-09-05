//
//  Meal.swift
//  FoodTracker
//
//  Created by admin on 7/31/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
class Meal: NSObject, NSCoding {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
                return lhs.name == rhs.name
            }
    
    //MARK: Properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    init?(name: String, photo: UIImage?, rating: Int) {
        
        //ten khong phai trong
        guard !name.isEmpty else {
            return nil
        }
        
        //xep hang nam tu 0 den 5
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //khoi tao thuoc tinh luu tru
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
    }
    
   
}

