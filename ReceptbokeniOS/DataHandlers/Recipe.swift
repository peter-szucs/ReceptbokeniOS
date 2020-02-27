//
//  Recipe.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-06.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Recipe {
    
    let ingredientAmountType: [String] = ["st", "tsk", "krm", "msk", "ml", "cl", "dl", "l", "mg", "g", "hg", "kg"]
    
    var title: String
    var isFavorite: Bool
    var imageID: String
    var author: String
    var portions: Int
    var time: String
    var tags: [String]
    var ingredients: [String]
    var ingredAmount: [Int]
    var ingredType: [Int]
    var howTo: [String]
    
    
    init(title: String, isFavorite: Bool = false, imageID: String, author: String, portions: Int, time: String, tags: [String], ingredients: [String], ingredAmount: [Int], ingredType: [Int], howTo: [String]) {
        self.title = title
        self.isFavorite = isFavorite
        self.imageID = imageID
        self.author = author
        self.portions = portions
        self.time = time
        self.tags = tags
        self.ingredients = ingredients
        self.ingredAmount = ingredAmount
        self.ingredType = ingredType
        self.howTo = howTo
    }
    
    
    // TODO: kolla implementera nil init på denna för felhantering
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        self.title = snapshotValue["title"] as! String
        self.isFavorite = snapshotValue["isFavorite"] as! Bool
        self.imageID = snapshotValue["imageID"] as! String
        self.author = snapshotValue["author"] as! String
        self.portions = snapshotValue["portions"] as! Int
        self.time = snapshotValue["time"] as! String
        self.tags = snapshotValue["tags"] as! [String]
        self.ingredients = snapshotValue["ingredients"] as! [String]
        self.ingredAmount = snapshotValue["ingredAmount"] as! [Int]
        self.ingredType = snapshotValue["ingredType"] as! [Int]
        self.howTo = snapshotValue["howTo"] as! [String]
//        } else {
//            return nil
//        }
    }
    
    func switchFavorite() {
        isFavorite = !isFavorite
    }
    
    func toDictionary() -> [String: Any] {
        return ["title": title,
                "isFavorite": isFavorite,
                "imageID": imageID,
                "author": author,
                "portions": portions,
                "time": time,
                "tags": tags,
                "ingredients": ingredients,
                "ingredAmount": ingredAmount,
                "ingredType": ingredType,
                "howTo": howTo]
    }
    
}
