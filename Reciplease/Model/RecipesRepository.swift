//
//  RecipesManager.swift
//  Reciplease
//
//  Created by Lilian Grasset on 12/07/2023.
//

import Foundation

class RecipesRepository {
    static let shared = RecipesRepository()
    private init(){}
    
    var recipes: [Recipe] = []
    var favorites: [Recipe] = []
}
