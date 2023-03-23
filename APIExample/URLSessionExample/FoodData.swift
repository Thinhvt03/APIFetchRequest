//
//  FoodData.swift
//  URLSessionExample

import Foundation

struct Meals: Codable {
    
    var strMeal: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strTags: String?
    
}

struct FoodsData: Codable {
    var meals: [Meals]
}
