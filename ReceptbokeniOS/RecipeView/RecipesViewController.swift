//
//  RecipesViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-04.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    let showRecipeContent = "ShowRecipeContent"
    
    var db: Firestore!
    var pageTitle: String = ""
    var recipesArray: [Recipe] = []
    var recipesDictionaryArray: [String: Any] = [:]
    var titleArray: [String] = []
    var favArray: [Bool] = []
    
    let tableListCellID = "RecipeListCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        db = Firestore.firestore()
        table.dataSource = self
        table.delegate = self
        loadData {
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableListCellID, for: indexPath) as! RecipeListTableViewCell
        cell.setTableVTwo(title: recipesArray[indexPath.row].title, isFav: recipesArray[indexPath.row].isFavorite, image: recipesArray[indexPath.row].imageID)
        return cell
    }
    
    func loadData(completion: @escaping () -> ()) {
        let recipesRef = db.collection("Recipes")
        var tempArray: [Recipe] = []
        var counter: Int = 0
        
        recipesRef.addSnapshotListener() { (snapshot, error) in
                    
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let item = Recipe(snapshot: document)
                tempArray.append(item)
                self.recipesArray.append(item)
                self.recipesDictionaryArray["title"] = item.title
                self.recipesDictionaryArray["isFavorite"] = item.isFavorite
                self.titleArray.append(item.title)
                self.favArray.append(item.isFavorite)
                
//                print(self.titleArray[counter])
                counter += 1
            }
            completion()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == showRecipeContent {
            guard let destinationVC = segue.destination as? RecipeContentViewController else {return}
            guard let cell = sender as? UITableViewCell else {return}
            guard let indexPath = table.indexPath(for: cell) else {return}
            let nextVCRecipe = recipesArray[indexPath.row]
            
            destinationVC.theRecipe = nextVCRecipe
//            destinationVC.pageTitle = nextVCRecipe.title
//            destinationVC.image = nextVCRecipe.imageID
        }
    }
    

}
