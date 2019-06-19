//
//  DescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher

class DescriptionViewController: UIViewController {
    
    var nameRecipe = String()
    var ingredients = String()
    var imageRecipe = UIImage()
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UITextView!
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.image = imageRecipe
        nameRecipeLabel.text = nameRecipe
        ingredientsLabel.text = ingredients
    }
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
