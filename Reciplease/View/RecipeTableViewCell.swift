//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Lilian Grasset on 20/07/2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeTimeDisplayer: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with recipeData: RecipeData) {
        recipeImageView.setImage(from: URL(string: recipeData.image)!)
        recipeImageView.contentMode = .scaleAspectFill
        
        recipeTitle.text = recipeData.label
        recipeIngredients.text = recipeData.ingredientList.joined(separator: ", ")
        
        if recipeData.totalTime == 0 {
            recipeTimeDisplayer.isHidden = true
        } else {
            recipeTime.text = TimeFormatter.format(recipeData.totalTime)
        }
    }
}
