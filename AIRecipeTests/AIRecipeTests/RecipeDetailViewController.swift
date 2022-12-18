//
//  RecipeDetailViewController.swift
//  AIRecipeTests
//
//  Created by Liam on 18/12/2022.
//

import UIKit
import Foundation

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeDetailTextView: UITextView!
    
    //@IBOutlet weak var recipeImageView: UIImageView!
    //@IBOutlet weak var recipeIngredientsTextView: UITextView!
    //@IBOutlet weak var recipeInstructionsTextView: UITextView!

    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        recipeDetailTextView.text = recipe.title
        //recipeIngredientsTextView.text = recipe.ingredients.joined(separator: ", ")
        //recipeInstructionsTextView.text = recipe.instructions

        // Load the recipe image
        //if let url = URL(string: recipe.imageUrl) {
        //    recipeImageView.kf.setImage(with: url)
        //}
    }
}
