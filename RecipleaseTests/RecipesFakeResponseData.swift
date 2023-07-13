//
//  RecipesFakeResponseData.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 11/07/2023.
//

import Foundation

class RecipesFakeResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://api.edamam.com/api/recipes/v2")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    
    static let responseNotOk = HTTPURLResponse(url: URL(string: "https://api.edamam.com/api/recipes/v2")!, statusCode: 401, httpVersion: nil, headerFields: [:])
    
    class RecipesError: Error {}
    static let error = RecipesError()
    
    static var recipesCorrectData: Data {
        let bundle = Bundle(for: RecipesFakeResponseData.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let recipesIncorrectData = "error".data(using: .utf8)
}
