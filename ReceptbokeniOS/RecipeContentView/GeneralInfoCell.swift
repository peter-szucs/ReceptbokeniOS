//
//  GeneralInfoCell.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-12.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import FirebaseStorage

class GeneralInfoCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var leftGeneralLabel: UILabel!
    
    @IBOutlet weak var rightGeneralLabel: UILabel!
    
    
//    func setGeneralCell(imageRef: String) {
//    
//        let storageRef = Storage.storage().reference(withPath: "images/\(imageRef)")
//        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self]  (data, error) in
//            if let error = error {
//                print("Error downloading picture: \(error.localizedDescription)")
//                return
//            }
//            if let data = data {
//                self.recipeImage.image = UIImage(data: data)
//            }
//        }
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
