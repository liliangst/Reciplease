//
//  Recipe+Extension.swift
//  Reciplease
//
//  Created by Lilian Grasset on 13/07/2023.
//

import Foundation
import CoreData

// Adding an extention to the class created by xcode to init a Recipe easily with a RecipeData object
extension Recipe {
    var data: RecipeData {
        let ingredientsData = ingredients!.allObjects.compactMap({($0 as! Ingredient).data})
        return RecipeData(label: self.label ?? "",
                          image: self.imageUrl ?? "",
                          totalTime: Int(self.totalTime),
                          ingredients: ingredientsData,
                          url: self.url ?? "",
                          isFavorite: true)
    }
}
