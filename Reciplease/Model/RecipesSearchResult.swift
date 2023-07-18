//
//  RecipesSearchResult.swift
//  Reciplease
//
//  Created by Lilian Grasset on 11/07/2023.
//

import Foundation

struct RecipesSearchResult: Decodable {
    private var hits: [RecipeHit]
    
    var count: Int
}

extension RecipesSearchResult {
    var list: [RecipeData] {
        hits.compactMap({$0.recipe})
    }
}

private struct RecipeHit: Decodable {
    var recipe: RecipeData
}
