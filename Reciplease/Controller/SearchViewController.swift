//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Lilian Grasset on 06/07/2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.isEnabled = false
        }
    }
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.isEnabled = false
        }
    }
    
    private let cellIdentifier = "IngredientCell"
    private let segueToRecipesIdentifier = "SearchRecipes"

    var list: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToRecipesIdentifier {
            let destinationVC = segue.destination as! RecipesViewController
            destinationVC.source = .search
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func addIngredientToList() {
        list.append(ingredientTextField.text!)
        ingredientTextField.text?.removeAll()
        addButton.isEnabled = false
        ingredientsTableView.reloadData()
    }

    @IBAction func clearIngredientList() {
        list.removeAll()
        
        ingredientsTableView.reloadData()
    }

    @IBAction func searchForRecipes() {
        toggleShowActivityIndicator(show: true)
        RecipesService.shared.fetchRecipes(with: list) { result in
            switch result {
            case .success(let recipes):
                RecipesRepository.shared.recipes = recipes
                self.performSegue(withIdentifier: self.segueToRecipesIdentifier,
                             sender: self)
            case .failure(_):
                self.displayError()
            }
            self.toggleShowActivityIndicator(show: false)
        }
    }
    
    private func toggleShowActivityIndicator(show: Bool) {
        if show {
            searchButton.configuration?.showsActivityIndicator = true
        } else {
            searchButton.configuration?.showsActivityIndicator = false
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count > 0 {
            searchButton.isEnabled = true
        } else {
            searchButton.isEnabled = false
        }

        return list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "- " + list[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textInput = textField.text else {
            return true
        }

        let text = (textInput as NSString).replacingCharacters(in: range, with: string)
        
        if text.isEmpty {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
        
        return true
    }
}

extension SearchViewController {
    
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
