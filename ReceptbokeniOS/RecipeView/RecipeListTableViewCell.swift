//
//  RecipeListTableViewCell.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-04.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import FirebaseStorage

class RecipeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeLikeIcon: UIImageView!
    
//    func setTableView(recipe: Recipe) {
//        recipeLabel.text = recipe.title
//        if recipe.isFavorite {
//            recipeLikeIcon.image = #imageLiteral(resourceName: "isFavTrue")
//        } else {
//            recipeLikeIcon.image = #imageLiteral(resourceName: "isFavFalse")
//        }
//    }
    
    func setTableVTwo(title: String, image: String, isFavorite: Bool) {
        let storageRef = Storage.storage().reference(withPath: "images/\(image)")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self]  (data, error) in
            if let error = error {
                print("Error downloading picture: \(error.localizedDescription)")
                return
            }
            if let data = data {
                self?.recipeImage.image = UIImage(data: data)
            }
        }
        recipeLabel.text = title
        if isFavorite {
            recipeLikeIcon.image = #imageLiteral(resourceName: "favorites")
        } else {
            recipeLikeIcon.image = #imageLiteral(resourceName: "isFavFalse")
        }

    }
}
