//
//  RecipeData.swift
//  Reciplease
//
//  Created by Lilian Grasset on 10/07/2023.
//

import Foundation

struct RecipeData: Decodable {
    var label: String
    var image: String
    var ingredientDescription: [String] {
        ingredients.compactMap({$0.text.capitalized})
    }
    var ingredientList: [String] {
        ingredients.compactMap({$0.food.capitalized})
    }
    var totalTime: Double
    
    var ingredients: [IngredientData]
}
