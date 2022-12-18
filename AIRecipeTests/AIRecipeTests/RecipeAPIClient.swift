//
//  RecipeAPIClient.swift
//  AIRecipeTests
//
//  Created by Liam on 18/12/2022.
//

import Foundation



class RecipeAPIClient
{
    static let shared = RecipeAPIClient(apiKey: "9d5544857380426eabcc12e48cd39b64", baseURL: URL(string: "https://api.spoonacular.com/recipes/findByIngredients")!)
    
    let apiKey: String
    let baseURL: URL
    
    init(apiKey: String, baseURL: URL) {
            self.apiKey = apiKey
            self.baseURL = baseURL
        }

    func searchRecipes(ingredients: String,
                       numberOfResults: String,
                       completion: @escaping ([Recipe]) -> Void)
    {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        components.queryItems = [URLQueryItem(name: "apiKey", value: apiKey),
                                 URLQueryItem(name: "number", value: numberOfResults)]

        let ingredientsString = ingredients.split(separator: ",").joined(separator: ",")
        components.queryItems?.append(URLQueryItem(name: "ingredients", value: ingredientsString))

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
    
    func fetchInstructions(recipeID: Int, completion: @escaping (Instruction) -> Void) {
        let instructionsURL = URL(string: "https://api.spoonacular.com/recipes/\(recipeID)/analyzedInstructions?apiKey=\(apiKey)")!

        let task = URLSession.shared.dataTask(with: instructionsURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode([Instruction].self, from: data)
                completion(response[0])
            } catch {
                print("Error: Could not decode response")
            }
        }

        task.resume()
    }
}
