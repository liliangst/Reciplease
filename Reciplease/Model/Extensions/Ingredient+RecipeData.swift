//
//  Ingredient+Extension.swift
//  Reciplease
//
//  Created by Lilian Grasset on 14/07/2023.
//

import Foundation
import CoreData

extension Ingredient {
    var data: IngredientData {
        IngredientData(food: self.name!, text: self.text!)
    }
}
