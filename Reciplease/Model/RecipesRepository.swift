//
//  RecipesManager.swift
//  Reciplease
//
//  Created by Lilian Grasset on 12/07/2023.
//

import Foundation
import CoreData

enum RepositoryError: Error {
    case RemoveRecipeNotSaved
}

class RecipesRepository {
    static let shared = RecipesRepository()
    private init() {
        self.coreDataStack = CoreDataStack()
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    init(coreDataStack: CoreDataStack, managedObjectContext: NSManagedObjectContext){
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
    }
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    var recipes: [RecipeData] = []
    var favorites: [RecipeData] = []
    
    func save(recipeData: RecipeData) {
        let recipe = Recipe(context: coreDataStack.mainContext)
        recipe.label = recipeData.label
        recipe.imageUrl = recipeData.image
        recipe.totalTime = recipeData.totalTime
        recipeData.ingredients.forEach { ingredientData in
            let ingredient = Ingredient(context: coreDataStack.mainContext)
            ingredient.name = ingredientData.food
            ingredient.text = ingredientData.text
            ingredient.recipe = recipe
            recipe.addToIngredients(ingredient)
        }
        
        coreDataStack.saveContext(managedObjectContext)
    }
    
    func remove(recipeData: RecipeData, completion: (Error?) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "label = %@", recipeData.label)
        do {
            guard let recipe = try managedObjectContext.fetch(request).first else {
                completion(RepositoryError.RemoveRecipeNotSaved)
                return
            }
            managedObjectContext.delete(recipe)
            coreDataStack.saveContext(managedObjectContext)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func getFavorites(completion: (Result<[RecipeData], Error>) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let favorites = try managedObjectContext.fetch(request)
            completion(.success(favorites.compactMap({$0.data})))
        } catch {
            completion(.failure(error))
        }
    }
}
