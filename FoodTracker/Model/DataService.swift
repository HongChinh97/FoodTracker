//
//  File.swift
//  FoodTracker
//
//  Created by admin on 9/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log
import CoreData

class DataService: Equatable {
    static func == (lhs: DataService,rsh: DataService) -> Bool {
        return lhs.mocMeals == rsh.mocMeals
    }
    
    static let shared: DataService = DataService()
    private var _mocMeals: [Food]?
    
    var mocMeals: [Food] {
        get {
            if _mocMeals == nil {
//                loadDataFood()
                loadDataEntity()
            }
            return _mocMeals ?? []
        }
        set {
            _mocMeals = newValue
        }
    }
    
//    func loadDataFood() {
//        _mocMeals = []
//        do {
//            _mocMeals = try
//            AppDelegate.context.fetch(Food.fetchRequest()) as? [Food]
//        } catch let error as NSError {
//            print(error)
//        }
//    }
    
    func loadDataEntity()  {
        _mocMeals = []
        do {
            _mocMeals = try AppDelegate.context.fetch(Food.fetchRequest()) as? [Food]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func remove(food: Food) {
//        loadDataFood()
        AppDelegate.context.delete(food)
        saveData()
    }
    
    func saveData() {
        AppDelegate.saveContext()
    }
}
