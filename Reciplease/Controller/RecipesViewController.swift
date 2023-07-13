//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Lilian Grasset on 07/07/2023.
//

import UIKit

class RecipesViewController: UITableViewController {

    var source: Source = .favorite
    
    enum Source {
        case search, favorite
    }
    
    private var recipesList: [Recipe] {
        switch source {
        case .favorite:
            return RecipesRepository.shared.favorites
        case .search:
            return RecipesRepository.shared.recipes
        }
    }
    
    private static let cellIdentifier = "RecipeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension RecipesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipesViewController.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = recipesList[indexPath.row].label
        
        return cell
    }
}
