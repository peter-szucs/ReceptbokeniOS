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
    
    func setTableVTwo(title: String, isFav: Bool, image: String) {
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
        if isFav {
            recipeLikeIcon.image = #imageLiteral(resourceName: "isFavTrue")
        } else {
            recipeLikeIcon.image = #imageLiteral(resourceName: "isFavFalse")
        }
//        recipeImage.image =
        
        //TODO: ändra hur favorites hanteras. Personligt dokument med receptID's som är favorites länkade kanske?
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
