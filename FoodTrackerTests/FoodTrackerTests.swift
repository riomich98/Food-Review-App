//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Rio Michelini on 24/02/2021.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

	// MARK: Meal Class Tests
	
	// Confirm that the Meal initialiser returns a Meal object when passed valid parameters.
	func testMealInitialisationSucceeds_withValidData() {
		let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
		XCTAssertNotNil(zeroRatingMeal)
		
		let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
		XCTAssertNotNil(positiveRatingMeal)
	}
	
	func testMealInitialisationFails_WithInvalidData() {
		let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
		XCTAssertNil(negativeRatingMeal)
		
		let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 7)
		XCTAssertNil(largeRatingMeal)
		
		let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
		XCTAssertNil(emptyStringMeal)
	}
	
}
