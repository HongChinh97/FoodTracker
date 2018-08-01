//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by admin on 7/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK: Meal class tests
    func testMealInitializationSucceeds() {
        
        // xep hang 0
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // xep hang cao nhat
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //xac nhan bua an tra ve nil khi vuot qua xep hang hoac ten trong
    func testMealInitiallizaionFails() {
        
        // xep hang tieu cuc
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // xep hang vuot qua toi da
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // ten trong
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
    }
}
