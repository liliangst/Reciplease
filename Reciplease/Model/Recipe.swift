//
//  Recipe.swift
//  Reciplease
//
//  Created by Lilian Grasset on 10/07/2023.
//

import Foundation

struct Recipe: Decodable {
    var label: String
    var image: String
    var ingredientLines: [String]
    var ingredientList: [String] {
        ingredients.compactMap({$0.food.capitalized})
    }
    var totalTime: Double
    
    private var ingredients: [Ingredient]
}

private struct Ingredient: Decodable {
    var food: String
}
