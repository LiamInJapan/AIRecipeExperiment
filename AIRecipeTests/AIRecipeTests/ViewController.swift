//
//  ViewController.swift
//  AIRecipeTests
//
//  Created by Liam on 18/12/2022.
//

import UIKit
import Foundation

let API_KEY = "9d5544857380426eabcc12e48cd39b64"
let INGREDIENTS = ["tomatoes", "onions", "spaghetti", "Parmesan cheese", "bell peppers", "chocolate"]
let NUMBER_OF_RESULTS = 10
let baseURL = URL(string: "https://api.spoonacular.com/recipes/findByIngredients")!

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

let instructionsURL = URL(string: "https://api.spoonacular.com/recipes/729366/analyzedInstructions?apiKey=9d5544857380426eabcc12e48cd39b64")!

class RecipeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.titleLabel.text = recipe.title
        return cell
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let ingredients = ingredientsTextView.text ?? ""
        let numberOfResults = numberOfResultsTextField.text ?? ""
        
        let apiClient = RecipeAPIClient.shared
        
        apiClient.searchRecipes(ingredients: ingredients, numberOfResults: numberOfResults) { recipes in
            let results = recipes.map { "\($0.id) \($0.title) \($0.image) \($0.usedIngredientCount) \($0.missedIngredientCount) \($0.likes)" }.joined(separator: "\n")
            
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

