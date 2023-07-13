//
//  RecipesService.swift
//  Reciplease
//
//  Created by Lilian Grasset on 10/07/2023.
//

import Foundation
import Alamofire

class RecipesService {
    static let shared = RecipesService()
    private init(){}
    
    private var apiUrl = "https://api.edamam.com/api/recipes/v2"
    private var session = Session(configuration: .default)
    
    init(session: Session, url: String) {
        self.session = session
        self.apiUrl = url
    }
    
    func fetchRecipes(with ingredients: [String], callback: @escaping (Result<[Recipe], Error>) -> Void) {
        session.request(apiUrl, method: .get, parameters: ["app_id": Constants.app_id,
                                                      "app_key": Constants.app_key,
                                                      "type": "public",
                                                      "q": ingredients.joined(separator: ",")])
        .validate()
        .responseDecodable(of: RecipesSearchResult.self) { response in
            switch response.result {
            case .success(let recipes):
                callback(.success(recipes.list))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}

