//
//  File.swift
//  FoodTracker
//
//  Created by admin on 9/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
class DataService: NSObject {
    static let shared: DataService = DataService()
    private var _meals : [Meal]?
    var meals: [Meal] {
        get {
            if _meals == nil {
                loadSampleMeals()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
        
        
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        _meals = [meal1, meal2, meal3]
    }
    
   func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
}
