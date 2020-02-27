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
    var auth: Auth!
    var pageTitle: String = ""
    var recipesArray: [Recipe] = []
    var favArray: [Recipe] = []
    
    let tableListCellID = "RecipeListCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        db = Firestore.firestore()
        auth = Auth.auth()
//        guard let user = auth.currentUser else {return}
//        let uid = user.uid
//        print(uid)
        table.dataSource = self
        table.delegate = self
        self.hideKeyboardWhenTappedAround()
//        loadFavorites {
//            self.table.reloadData()
//        }
        loadData {
            self.table.reloadData()
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableListCellID, for: indexPath) as! RecipeListTableViewCell
        cell.setTableVTwo(title: recipesArray[indexPath.row].title, image: recipesArray[indexPath.row].imageID, isFavorite: recipesArray[indexPath.row].isFavorite)
            
        return cell
    }
    
    // MARK: - Load data from DB
    
    func loadData(completion: @escaping () -> ()) {
        var recipeIDArray: [String] = []
        var recipeIDFavoritesArray: [String] = []
        guard let user = auth.currentUser else {return}
        let uid = user.uid
        let favoritesRef = db.collection("users").document(uid)
        favoritesRef.addSnapshotListener() { (document, error) in
            if let error = error {
                print(error)
                return
            }
            if let document = document, document.exists {
                recipeIDFavoritesArray = document["favorites"] as! [String]
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data recipesviewcontroller: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
                
            
            
            let recipesRef = self.db.collection("Recipes")
            
            // !!!don't add snapshotlistener in another snapshotlietener
            // will add new listener evewr time favorites is updated
            recipesRef.getDocuments() { (snapshot, error) in
                
                guard let documents = snapshot?.documents else {return}
                
                // remove from array
                self.recipesArray.removeAll()
                self.favArray.removeAll()
                
                for document in documents {
                    let id = document.documentID
                    recipeIDArray.append(id)
                    if recipeIDFavoritesArray.contains(id) {
                        let item = Recipe(snapshot: document, isFavorite: true, recipeID:  id)
                        self.recipesArray.append(item)
                        self.favArray.append(item)
                    } else {
                        let item = Recipe(snapshot: document, recipeID: id)
                        self.recipesArray.append(item)
                    }
                }
                
                completion()
            }
        }
        
        
    }
    
//    func loadFavorites(completion: @escaping () -> ()) {
//        guard let user = auth.currentUser else {return}
//        let uid = user.uid
//        let favoritesRef = db.collection("users").document(uid)
//        var recipeIDArray: [String] = []
//        favoritesRef.addSnapshotListener() { (document, error) in
//           // guard let documents =  else {return}
//            if let error = error {
//                print(error)
//                return
//            }
//            recipeIDArray = document?["favorites"] as! [String]
//            completion()
//        }
//        
//    }
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
