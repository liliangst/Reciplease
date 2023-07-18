//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 17/07/2023.
//

import Foundation
import CoreData
import Reciplease

final class TestCoreDataStack: CoreDataStack {
    override init() {
      super.init()

      let persistentStoreDescription = NSPersistentStoreDescription()
      persistentStoreDescription.type = NSInMemoryStoreType

      let container = NSPersistentContainer(
        name: CoreDataStack.modelName)
      container.persistentStoreDescriptions = [persistentStoreDescription]

      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }

      storeContainer = container
    }
  }
