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
    
    var recipe: Recipe!
    var _instructions: Instruction?

    override func viewDidLoad() {
        super.viewDidLoad()

        recipeStepsTableView.dataSource = self
        recipeStepsTableView.delegate = self
        
        recipeTitleLabel.text = recipe.title
        
        let apiClient = RecipeAPIClient.shared
        
        apiClient.fetchInstructions(recipeID: recipe.id) { instructions in
            self._instructions = instructions
        }
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _instructions?.steps.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepCell", for: indexPath) as! RecipeStepCell
        let step = _instructions?.steps[indexPath.row]
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
