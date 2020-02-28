//
//  RecipeContentViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-07.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase

class RecipeContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    
    
    
    let generalInfoCellID = "GeneralInfo"
    let tagsCellID = "TagCell"
    let ingredientsCellID = "IngredientsCellID"
    let howToCellID = "HowToCellID"
    var ingredientsArray: [String] = []
    var ingredientsAmountArray: [String] = []
    var generalLabelText: String = ""
    var imageRefID: String = ""
    var recipeIDFavoritesArray: [String] = []
    var tagString: String = ""
    
    var db: Firestore!
    var theRecipe: Recipe!
    
    var comingFromNewRecipe: Bool = false
    
    var auth: Auth!


    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        db = Firestore.firestore()
        auth = Auth.auth()
        self.title = theRecipe?.title
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 300.0
        self.table.reloadData()
        table.layer.backgroundColor = UIColor.white.cgColor
        guard let authorTemp = theRecipe?.author else {return}
        guard let portionsTemp = theRecipe?.portions else {return}
        guard let timeTemp = theRecipe?.time else {return}
        generalLabelText = makeGeneralLabelText(author: authorTemp, portions: portionsTemp, time: timeTemp)
        guard let ingreds = theRecipe?.ingredients else {return}
        guard let ingredsAmount = theRecipe?.ingredAmount else {return}
        guard let ingredsType = theRecipe?.ingredType else {return}
        guard let ingredsTypeConverted = theRecipe?.ingredientAmountType else {return}
        
        for i in 0..<ingreds.count {
            ingredientsArray.append(ingreds[i])
            let number = ingredsType[i]
            let type = ingredsTypeConverted[number]
            let typeNumber = String(ingredsAmount[i])
            ingredientsAmountArray.append("\(typeNumber) \(type)")
            
        }
        makeTagString()
        guard let imageRefIDo = theRecipe?.imageID else {return}
        imageRefID = imageRefIDo
        changeFavoritedBackground()
        print("Fav: \(theRecipe.isFavorite)")
    }
    
    func makeGeneralLabelText(author: String, portions: Int, time: String) -> String {
        var tempReturn: String = ""
        let newLine = "\n"
        tempReturn += author + newLine
        tempReturn += String(portions) + newLine
        tempReturn += time
        return tempReturn
    }
    
    func makeTagString() {
        let separator = ", "
        var counter = 0
        for i in theRecipe.tags {
            tagString += i
            counter += 1
            if !(counter == theRecipe.tags.count) {
                tagString += separator
            }
            
        }
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return theRecipe.ingredients.count
        } else {
            return theRecipe.howTo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: generalInfoCellID) as! GeneralInfoCell
            let imageRefID = theRecipe.imageID
                let storageRef = Storage.storage().reference(withPath: "images/\(imageRefID)")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self]  (data, error) in
                if let error = error {
                    print("Error downloading picture: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    cell.recipeImage.image = UIImage(data: data)
                }
            }
            cell.leftGeneralLabel.text = "Skapad av: \nAntal portioner: \nTillagningstid: "
            cell.rightGeneralLabel.text = generalLabelText
            return (cell)
        } else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: tagsCellID) as! TagsViewCell
            cell.tagsLabel.text = tagString
            return cell
        } else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsCellID, for: indexPath) as! RecipeIngredientsTableViewCell
            
            cell.setIngredientCell(ingred: ingredientsArray[indexPath.row], amount: ingredientsAmountArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: howToCellID, for: indexPath) as! HowToCell
//            cell.numberLbl.text = "\(indexPath.row + 1)."
            cell.howToText.text = "\(theRecipe.howTo[indexPath.row])\n"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 337
        } else if indexPath.section == 1 {
            return 62
        } else if indexPath.section == 2{
            return 35
        } else {
            return table.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Taggar"
        case 2:
            return "Ingridienser"
        case 3:
            return "Tillagning"
        default:
            return ""
        }
    }
    
    func setFavorite() {
        guard let user = auth.currentUser else {return}
        let uid = user.uid
        if theRecipe.isFavorite {
            var tempArray: [String] = []
            theRecipe.isFavorite = false
            
            let favoritesRef = self.db.collection("users").document(uid)
            favoritesRef.getDocument { (document, error) in
//                if let error = error {
//                    print(error)
//                    return
//                } else {
                if let document = document, document.exists {
                    self.recipeIDFavoritesArray = document["favorites"] as! [String]
                    for i in self.recipeIDFavoritesArray {
                        if (i == self.theRecipe.recipeIDString) {
                            print("Not adding this")
                        } else {
                            tempArray.append(i)
                        }
                    }
                    self.db.collection("users").document(uid).setData([ "favorites" : tempArray ])
                }
//                }
            }
            // image transform och ta bort ref i DB
            changeFavoritedBackground()
//            for i in self.recipeIDFavoritesArray {
//                if (i == theRecipe.recipeIDString) {
//                    print("Not adding this")
//                }
//                tempArray.append(i)
//            }
//            db.collection("users").document(uid).setData([ "favorites" : tempArray ])
            
        } else {
            theRecipe.isFavorite = true
            let dbRef = self.db.collection("users").document(uid)
            dbRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.recipeIDFavoritesArray = document["favorites"] as! [String]
                    var tempArray: [String] = []
                    for i in self.recipeIDFavoritesArray {
                        tempArray.append(i)
                    }
                    tempArray.append(self.theRecipe.recipeIDString)
                    dbRef.setData([ "favorites": tempArray ])
                    self.changeFavoritedBackground()
                } else {
                    print("Document does not exist, creating new")
                    self.db.collection("users").document(uid).setData( ["favorites" : [self.theRecipe.recipeIDString] ])
                }
            }
//            let favoritesRef = db.collection("users").document(uid)
//            favoritesRef.getDocument { (document, error) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                self.recipeIDFavoritesArray = document?["favorites"] as! [String]
//            }
//            var tempArray: [String] = []
//            for i in recipeIDFavoritesArray {
//                tempArray.append(i)
//            }
//            favoritesRef.setData([ "favorites": tempArray ])
//            changeFavoritedBackground()
        }
    }
    
    func changeFavoritedBackground() {
        if theRecipe.isFavorite {
            favoritesButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
        } else {
            favoritesButton.setImage(#imageLiteral(resourceName: "isFavFalse"), for: .normal)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        setFavorite()
    }
    
    
}
