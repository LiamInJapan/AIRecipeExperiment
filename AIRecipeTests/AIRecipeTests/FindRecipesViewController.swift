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
    var recipesByMissingIngredients: [(Int, Recipe)] = []
    
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

                    // Create the dictionary that maps the number of missing ingredients to the corresponding recipes
                    var recipesByMissingIngredients: [Int: Recipe] = [:]
                    for recipe in recipes {
                        recipesByMissingIngredients[recipe.id] = recipe
                    }

                    // Sort the keys in the dictionary in ascending order by the number of missing ingredients
                    let sortedKeys = recipesByMissingIngredients.keys.sorted { key1, key2 in
                        return recipesByMissingIngredients[key1]!.missedIngredientCount < recipesByMissingIngredients[key2]!.missedIngredientCount
                    }
                    self.recipesByMissingIngredients = sortedKeys.map { key in (recipesByMissingIngredients[key]!.missedIngredientCount, recipesByMissingIngredients[key]!) }
            
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of unique values for the number of missing ingredients
        return Set(recipesByMissingIngredients.map { $0.0 }).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Get the number of missing ingredients for the current section
        let missingIngredients = Array(Set(recipesByMissingIngredients.map { $0.0 }))[section]

        // Return the number of missing ingredients as the title for the section
        return "\(missingIngredients) ingredients needed"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the number of missing ingredients for the current section
        let missingIngredients = Array(Set(recipesByMissingIngredients.map { $0.0 }))[section]

        // Return the number of recipes with the specified number of missing ingredients
        return recipesByMissingIngredients.filter { $0.0 == missingIngredients }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell

        // Get the number of missing ingredients for the current section
        let missingIngredients = Array(Set(recipesByMissingIngredients.map { $0.0 }))[indexPath.section]

        // Get the recipe for the current row
        let recipe = recipesByMissingIngredients.filter { $0.0 == missingIngredients }.first?.1
        cell.titleLabel.text = recipe?.title
        return cell
    }
}

extension FindRecipesViewController: UITableViewDelegate {

}


class RecipeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
