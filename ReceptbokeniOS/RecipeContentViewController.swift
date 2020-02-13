//
//  RecipeContentViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-07.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RecipeContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    let generalInfoCellID = "GeneralInfo"
    let tagsCellID = "TagCell"
    let ingredientsCellID = "IngredientsCellID"
    let howToCellID = "HowToCellID"
    var ingredientsArray: [String] = []
    var ingredientsAmountArray: [String] = []
    var generalLabelText: String = ""
    var imageRefID: String = ""
    
    var theRecipe: Recipe!
//    var db: Firestore?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(theRecipe.howTo.count)
//        db = Firestore.firestore()
        self.title = theRecipe?.title
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44.0
        self.table.reloadData()
//        db?.collection("Recipes")
//        var generalLabelText: String
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
        
        guard let imageRefIDo = theRecipe?.imageID else {return}
        imageRefID = imageRefIDo
        print(imageRefID)
//        let storageRef = Storage.storage().reference(withPath: "images/\(imageRefID)")
//        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self]  (data, error) in
//            if let error = error {
//                print("Error downloading picture: \(error.localizedDescription)")
//                return
//            }
//            if let data = data {
//                self?.imageRef.image = UIImage(data: data)
//            }
//        }
        
    }
    func makeGeneralLabelText(author: String, portions: Int, time: String) -> String {
        var tempReturn: String = ""
        let newLine = "\n"
        tempReturn += author + newLine
        tempReturn += String(portions) + newLine
        tempReturn += time
        return tempReturn
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let cellAmount = theRecipe?.ingredients.count else { return 0 }
//        let cellAmount = theRecipe.ingredients.count
        if (section == 0) {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return theRecipe.ingredients.count
        } else {
            return theRecipe.howTo.count
        }
//        let number = theRecipe.ingredients.count + 2
//        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: generalInfoCellID) as! GeneralInfoCell
            let imageRefID = theRecipe.imageID
            //        print(imageRefID)
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
//            cell.setGeneralCell(imageRef: imageRefID)
            cell.leftGeneralLabel.text = "Skapad av: \nAntal portioner: \nTillagningstid: "
            cell.rightGeneralLabel.text = generalLabelText
            return (cell)
        } else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: tagsCellID) as! TagsViewCell
            return cell
        } else if (indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: ingredientsCellID, for: indexPath) as! RecipeIngredientsTableViewCell
            
            cell.setIngredientCell(ingred: ingredientsArray[indexPath.row], amount: ingredientsAmountArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: howToCellID, for: indexPath) as! HowToCell
            cell.numberLbl.text = "\(indexPath.row + 1)."
            cell.howToText.text = theRecipe.howTo[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 337
        } else if indexPath.section == 1 {
            return 62
        } else {
            return 35
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
