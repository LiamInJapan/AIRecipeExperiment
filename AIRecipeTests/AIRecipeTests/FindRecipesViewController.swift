//
//  ViewController.swift
//  AIRecipeTests
//
//  Created by Liam on 18/12/2022.
//

import UIKit
import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let likes: Int
}

struct Instruction: Codable {
    let name: String
    let steps: [Step]
}

struct Step: Codable {
    let number: Int
    let step: String
    let ingredients: [Ingredient]
    let equipment: [Equipment]
}

struct Ingredient: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
}

struct Equipment: Codable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
}

class FindRecipesViewController: UIViewController
{
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var numberOfResultsTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var recipeResultsTableView: UITableView!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let ingredients = ingredientsTextView.text ?? ""
        let numberOfResults = numberOfResultsTextField.text ?? ""
        
        let apiClient = RecipeAPIClient.shared
        
        apiClient.searchRecipes(ingredients: ingredients, numberOfResults: numberOfResults) { recipes in
            
            self.recipes = recipes
            
            DispatchQueue.main.async {
                self.recipeResultsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showRecipeDetail" {
            let detailViewController = segue.destination as! RecipeDetailViewController
            let selectedIndexPath = recipeResultsTableView.indexPathForSelectedRow!
            let selectedRecipe = recipes[selectedIndexPath.row]
            detailViewController.recipe = selectedRecipe
        }
    }
}

extension FindRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.titleLabel.text = recipe.title
        return cell
    }
}

extension FindRecipesViewController: UITableViewDelegate {

}


class RecipeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
