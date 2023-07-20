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
            return RecipesRepository.shared.recipes
        }
    }
    
    private static let cellIdentifier = "RecipeCell"
    private static let segueToSingleRecipeIndentifier = "SingleRecipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
