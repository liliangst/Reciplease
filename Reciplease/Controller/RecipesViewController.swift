//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Lilian Grasset on 07/07/2023.
//

import UIKit
import Kingfisher

class RecipesViewController: UITableViewController {

    var source: Source = .favorite
    
    enum Source {
        case search, favorite
    }
    
    private var recipesList: [RecipeData] {
        switch source {
        case .favorite:
            return RecipesRepository.shared.favorites
        case .search:
            return RecipesRepository.shared.recipes.map { recipe in
                guard let index = RecipesRepository.shared.favorites.firstIndex(of: recipe) else {
                    return recipe
                }
                return RecipesRepository.shared.favorites[index]
            }
        }
    }
    
    private static let cellIdentifier = "RecipeCell"
    private static let segueToSingleRecipeIndentifier = "SingleRecipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if case .favorite = source {
            RecipesRepository.shared.getFavorites { result in
                switch result {
                case .success(let favorites):
                    RecipesRepository.shared.favorites = favorites
                case .failure(_):
                    displayAlert("An error occured while fetching your favorites recipes.")
                }
            }
        }
        // Reloading data into recipesList
        _ = recipesList
        tableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipesViewController.cellIdentifier, for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipesList[indexPath.row]
        cell.configure(with: recipe)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RecipeTableViewCell else {
            return
        }
        RecipesRepository.shared.selectedRecipe = recipesList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: RecipesViewController.segueToSingleRecipeIndentifier, sender: cell)
    }
}

extension RecipesViewController {
    
    func displayError() {
        displayAlert("An error occured.")
    }
    
    private func displayAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Whoops!",
                                        message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
