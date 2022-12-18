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

/*
https://api.spoonacular.com/recipes/findByIngredients?apiKey=9d5544857380426eabcc12e48cd39b64&ingredients=tomatoes,onions,spaghetti,Parmesan%20cheese,bell%20peppers,chocolate&number=10
*/

func searchRecipes(ingredients: String,
                   numberOfResults: String,
                   completion: @escaping ([Recipe]) -> Void)
{
    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
    
    components.queryItems = [URLQueryItem(name: "apiKey",
                                          value: API_KEY),
                             URLQueryItem(name: "number", value: numberOfResults),    ]

    ingredients.split(separator: ",").forEach { ingredient in
        components.queryItems?.append(URLQueryItem(name: "ingredients", value: String(ingredient)))
    }

    guard let API_URL = components.url else {
        print("Error: Could not create URL")
        return
    }
    
    let task = URLSession.shared.dataTask(with: API_URL) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
       
        do {
            let response = try JSONDecoder().decode([Recipe].self, from: data)
            completion(response)
        } catch {
            print("Error: Could not decode response")
        }
    }
   
    task.resume()
}


func searchRecipesOld(completion: @escaping ([Recipe]) -> Void) {
    
    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
    components.queryItems = [
        URLQueryItem(name: "apiKey", value: API_KEY),
        URLQueryItem(name: "number", value: String(NUMBER_OF_RESULTS)),
    ]

    INGREDIENTS.enumerated().forEach { index, ingredient in
        components.queryItems?.append(URLQueryItem(name: "ingredients", value: ingredient))
    }

    let API_URL = components.url!

    print(API_URL)
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let likes: Int
}

class ViewController: UIViewController {

    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var numberOfResultsTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var recipeResultsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let ingredients = ingredientsTextView.text ?? ""
        let numberOfResults = numberOfResultsTextField.text ?? ""

        searchRecipes(ingredients: ingredients, numberOfResults: numberOfResults) { recipes in
            let results = recipes.map { "\($0.id) \($0.title) \($0.image) \($0.usedIngredientCount) \($0.missedIngredientCount) \($0.likes)" }.joined(separator: "\n")
            self.recipeResultsTextView.text = results
        }
    }


}

