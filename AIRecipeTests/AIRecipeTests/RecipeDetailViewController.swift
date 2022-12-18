//
//  RecipeDetailViewController.swift
//  AIRecipeTests
//
//  Created by Liam on 18/12/2022.
//

import UIKit
import Foundation

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeTitleLabel : UILabel!
    @IBOutlet weak var recipeStepsTableView: UITableView!
    
    
    //@IBOutlet weak var recipeImageView: UIImageView!
    //@IBOutlet weak var recipeIngredientsTextView: UITextView!
    //@IBOutlet weak var recipeInstructionsTextView: UITextView!

    var recipe: Recipe!
    var instructions: [Instruction]?

    func fetchInstructions() {
            // Replace with code to fetch instructions for recipe
            instructions = [Instruction(name: "", steps: [
                Step(number: 1, step: "Step 1", ingredients: [], equipment: []),
                Step(number: 2, step: "Step 2", ingredients: [], equipment: []),
                Step(number: 3, step: "Step 3", ingredients: [], equipment: [])
            ])]

            // Reload table view
            recipeStepsTableView.reloadData()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeStepsTableView.dataSource = self
        recipeStepsTableView.delegate = self
        
        recipeTitleLabel.text = recipe.title
        
        fetchInstructions()
        //recipeIngredientsTextView.text = recipe.ingredients.joined(separator: ", ")
        //recipeInstructionsTextView.text = recipe.instructions

        // Load the recipe image
        //if let url = URL(string: recipe.imageUrl) {
        //    recipeImageView.kf.setImage(with: url)
        //}
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions?.first?.steps.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepCell", for: indexPath) as! RecipeStepCell
        let step = instructions?.first?.steps[indexPath.row]
        cell.numberLabel.text = "\(step?.number ?? 0)"
        cell.stepLabel.text = step?.step
        return cell
    }
}

extension RecipeDetailViewController: UITableViewDelegate {

}

class RecipeStepCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
}
