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
    var totalTime: Int
    var ingredients: [IngredientData]
    var url: String
    
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
            case label, image, totalTime, ingredients, url
    }
}

extension RecipeData {
    var ingredientDescription: [String] {
        ingredients.compactMap({$0.text.capitalized})
    }
    var ingredientList: [String] {
        ingredients.compactMap({$0.food.capitalized})
    }
}

extension RecipeData: Equatable {
    static func == (lhs: RecipeData, rhs: RecipeData) -> Bool {
        return lhs.url == rhs.url
    }
}
