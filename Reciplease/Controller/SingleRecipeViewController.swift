//
//  SingleRecipeViewController.swift
//  Reciplease
//
//  Created by Lilian Grasset on 20/07/2023.
//

import UIKit
import WebKit

class SingleRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeTimeDisplayer: UIStackView! {
        didSet {
            guard let time = RecipesRepository.shared.selectedRecipe?.totalTime, time > 0 else {
                recipeTimeDisplayer.isHidden = true
                return
            }
        }
    }
    @IBOutlet weak var recipeTime: UILabel! {
        didSet {
            guard let time = RecipesRepository.shared.selectedRecipe?.totalTime, time > 0 else {
                return
            }
            recipeTime.text = TimeFormatter.format(time)
        }
    }
    @IBOutlet weak var recipeTitle: UILabel! {
        didSet {
            guard let title = RecipesRepository.shared.selectedRecipe?.label else {
                return
            }
            recipeTitle.text = title
        }
    }
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            guard let imageURL = RecipesRepository.shared.selectedRecipe?.image else {
                return
            }
            recipeImageView.setImage(from: URL(string: imageURL)!)
            recipeImageView.contentMode = .scaleAspectFill
        }
    }

    private static let ingredientCellIdentifier = "IngredientCell"
    private static let webViewSegue = "RecipeWebViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let starImage = RecipesRepository.shared.selectedRecipe?.isFavorite ?? false ? "star.fill" : "star"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: starImage),
            style: .plain, target: self,
            action: #selector(toggleFavorite))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        RecipesRepository.shared.selectedRecipe = nil
        _ = navigationController?.popViewController(animated: false)
    }

    @objc private func toggleFavorite() {
        RecipesRepository.shared.selectedRecipe?.isFavorite.toggle()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: RecipesRepository.shared.selectedRecipe?.isFavorite ?? false ? "star.fill" : "star")
        
        guard let selectedRecipe = RecipesRepository.shared.selectedRecipe else {
            return
        }
        
        if selectedRecipe.isFavorite {
            RecipesRepository.shared.save(recipeData: selectedRecipe)
        } else {
            RecipesRepository.shared.remove(recipeData: selectedRecipe) { error in
                guard error == nil else {
                    displayAlert("An error occured while removing this recipe from your favorites.")
                    return
                }
            }
        }
    }
    
    @IBAction func tapGetDirections() {
        guard RecipesRepository.shared.selectedRecipe?.url != nil else {
            displayAlert("Can't open web view for directions.")
            return
        }
        performSegue(withIdentifier: SingleRecipeViewController.webViewSegue, sender: self)
    }
}

extension SingleRecipeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipesRepository.shared.selectedRecipe?.ingredientDescription.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleRecipeViewController.ingredientCellIdentifier, for: indexPath)
        
        let ingredientDescription = RecipesRepository.shared.selectedRecipe?.ingredientDescription[indexPath.row] ?? ""
        cell.textLabel?.text = "- " + ingredientDescription
        
        return cell
    }
}

extension SingleRecipeViewController {
    private func displayAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Whoops!",
                                        message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
