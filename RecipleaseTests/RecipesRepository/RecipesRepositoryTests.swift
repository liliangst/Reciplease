//
//  RecipesRepositoryTests.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 14/07/2023.
//

import XCTest
@testable import Reciplease
import CoreData

final class RecipesRepositoryTests: XCTestCase {
    
    var repository: RecipesRepository!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        repository = RecipesRepository(coreDataStack: coreDataStack, managedObjectContext: coreDataStack.mainContext)
    }
    
    func testSaveRecipeShouldSuccess() {
        let derivedContext = coreDataStack.newDerivedContext()
        repository = RecipesRepository(coreDataStack: coreDataStack, managedObjectContext: derivedContext)
        let recipeData = RecipeData(label: "Test", image: "image", totalTime: 0, ingredients: [IngredientData(food: "test", text: "test test")], url: "")
        
        expectation(
          forNotification: .NSManagedObjectContextDidSave,
          object: coreDataStack.mainContext) { _ in
            return true
        }
        derivedContext.perform {
            self.repository.save(recipeData: recipeData)
        }
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testGetFavoriteShouldFail() {
        let wrongManagedObjectContext = {
            let container = NSPersistentContainer(name: "Test")
            container.loadPersistentStores { _, error in
              if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
              }
            }
            return container.viewContext
        }()
        repository = RecipesRepository(coreDataStack: coreDataStack, managedObjectContext: wrongManagedObjectContext)
        
        repository.getFavorites { result in
            switch result {
            case .success(_):
                XCTFail("Should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testGetFavoriteShouldSuccess() {
        let recipeData = RecipeData(label: "Test", image: "test", totalTime: 1, ingredients: [IngredientData(food: "Test", text: "test")], url: "")
        repository.save(recipeData: recipeData)
        
        repository.getFavorites { result in
            switch result {
            case .success(let recipes):
                XCTAssertFalse(recipes.isEmpty)
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
    }
    
    func testDeleteRecipeShouldFail() {
        let recipeData = RecipeData(label: "RemoveTest", image: "test", totalTime: 3, ingredients: [], url: "")
        
        repository.remove(recipeData: recipeData) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testDeleteRecipeShouldSuccess() {
        let recipeData = RecipeData(label: "Test", image: "test", totalTime: 1, ingredients: [IngredientData(food: "Test", text: "test")], url: "")
        repository.save(recipeData: recipeData)
        
        repository.remove(recipeData: recipeData) { error in
            XCTAssertNil(error)
        }
        
        repository.getFavorites { result in
            switch result {
            case .success(let recipes):
                XCTAssertTrue(recipes.isEmpty)
            case .failure(_):
                XCTFail("Recipe has not been removed.")
            }
        }
        
    }
}
