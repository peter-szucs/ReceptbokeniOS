//
//  RecipeIngredientsTableViewCell.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-11.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class RecipeIngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredient: UILabel!
    
    @IBOutlet weak var ingredAmount: UILabel!
    
    
    func setIngredientCell(ingred: String, amount: String) {
        ingredient.text = ingred
        ingredAmount.text = amount
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
