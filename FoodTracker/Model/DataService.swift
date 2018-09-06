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
                loadMeal()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
        
        
    }
    func loadMeal() {
        if let saveMeals = loadMeals() {
            _meals = saveMeals
        } else {
            loadSampleMeals()
        }
    }
    func loadSampleMeals() {

        guard let meal1 = Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: #imageLiteral(resourceName: "meal3"), rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        _meals = [meal1, meal2, meal3]
    }
    
   private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( _meals!, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    func editMeals(index: Int, meal: Meal) {
        _meals?[index] = meal
        saveMeals()
    }
    func addMeals(meal: Meal) {
        _meals?.append(meal)
        saveMeals()
    }
    func removeMeal(at index: Int) {
        _meals?.remove(at: index)
        saveMeals()
    }
}
