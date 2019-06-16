//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var hits = [Hit]()
    var favorite = [Recipe]()
    var imageFavorite = [UIImage]()
    var imageRecipe = [UIImage]()
    var userIngredients = [String]()
    @IBOutlet weak var loadMoreButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var apiHelper: APIHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        loadMoreButton.isHidden = true
        
    }
    
    @IBAction func loadMoreAction(_ sender: UIButton) {
        apiHelper?.from = apiHelper!.to + 1
        apiHelper?.to = apiHelper!.from + 9
        
        apiHelper?.getRecipe(userIngredients: userIngredients, callback: { (apiResult) in
            guard let apiResult = apiResult else { return }
            guard let hits = apiResult.hits else { return }
            self.hits.append(contentsOf: hits)
            self.tableView.reloadData()
        })
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// MARK: - TableView
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        tableView.separatorStyle = .none
        return hits.count
    }
    
    func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        let hit = hits[indexPath.row]
        let ingredients = hit.recipe.ingredientLines.joined(separator: ", ")
        let nameRecipe = hit.recipe.label
        let timeRecipe = hit.recipe.totalTime
        
        updateNameRecipeLabel(cell: cell, nameRecipe: nameRecipe)
        updateIngredientsLabel(cell: cell, ingredients: ingredients)
        updateTimeLabel(cell: cell, time: timeRecipe)
        getImage(cell: cell, hit: hit)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoritesAction = UITableViewRowAction(style: .default, title: "➕Favorites", handler: { (action, indexPath) in
            // add actions (save to favorites list) and core data
            let recipe = self.hits[indexPath.row].recipe
            let image = self.imageRecipe[indexPath.row]
            self.favorite.append(recipe)
            self.imageFavorite.append(image)
        })
        
        favoritesAction.backgroundColor = UIColor.darkText
        return [favoritesAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = tableView.frame.height / 3
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            fillCell(cell, with: hits, indexPath: indexPath)
            return cell
        }
        let cellStandard = UITableViewCell()
        return cellStandard
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == hits.count - 1 && hits.count >= 3 {
            loadMoreButton.isHidden = false
        }
    }
    
    func updateNameRecipeLabel(cell: ResultTableViewCell, nameRecipe: String) {
        cell.nameRecipeLabel.text = nameRecipe
    }
    
    func updateIngredientsLabel(cell: ResultTableViewCell, ingredients: String) {
        cell.ingredientsLabel.text = ingredients
    }
    
    func getImage(cell: ResultTableViewCell, hit: Hit) {
        guard let urlImage = hit.recipe.image else { return }
        if let apiHelper = apiHelper {
            apiHelper.getImage(url: urlImage) { (image) in
                cell.noImageLabel.isHidden = true
                cell.recipeImageView.image = image
                cell.recipeImageView.contentMode = .scaleAspectFill
                cell.recipeImageView.alpha = 0.7
            }
        }
    }
    
    func updateTimeLabel(cell: ResultTableViewCell, time: Double?) {
        if let timerecipe = time {
            let time = String(timerecipe)
            cell.timeLabel.text = time
        }
    }
}
