//
//  NewRecipeViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-18.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    let imagePicker = UIImagePickerController()
    var imageTemp: UIImage?
    
    var pageTitle: String = ""
    var newRecipe: Recipe?
    var newRecipeArray: [String : Any?] = [:]
    
    let singleInputCell = "SingleInputCell"
    let cookTimeInputCell = "CookTimeInputCell"
    let imageCell = "ImageCell"
    let multiSelectionCell = "MultiSelectionCell"
    let addTagsSegue = "AddTagsSeuge"
    let addIngredientsSegue = "AddIngredientsSegue"
    let addHowToSegue = "AddHowToSegue"
    
    var tagsAdded: [String] = []
    var ingredientsAdded: [String] = []
    var ingredientsAmountAdded: [Float] = []
    var ingredientsTypeAdded: [Int] = []
    var howToAdded: [String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        imagePicker.delegate = self
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: singleInputCell, for: indexPath) as! SingleInputCell
            cell.contentLabel.text = "Titel:"
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: singleInputCell, for: indexPath) as! SingleInputCell
            cell.contentLabel.text = "Portioner:"
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: singleInputCell, for: indexPath) as! SingleInputCell
            cell.contentLabel.text = "Skapad av:"
            return cell
        case 3:
            let cell = table.dequeueReusableCell(withIdentifier: cookTimeInputCell, for: indexPath) as! CookTimeInputCell
            return cell
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! ImageCell
            cell.recipeImage.layer.borderColor = UIColor.darkGray.cgColor
            cell.recipeImage.layer.borderWidth = 1.0
            cell.recipeImage.image = imageTemp
            return cell
        case 5:
            let cell = table.dequeueReusableCell(withIdentifier: multiSelectionCell, for: indexPath) as! MultiInputCell
            cell.mainLabel.text = "Lägg till taggar"
            cell.footerLabel.text = "\(tagsAdded.count) tillagda taggar"
            return cell
        case 6:
            let cell = table.dequeueReusableCell(withIdentifier: multiSelectionCell, for: indexPath) as! MultiInputCell
            cell.mainLabel.text = "Lägg till ingredienser"
            cell.footerLabel.text = "\(ingredientsAdded.count) tillagda"
            return cell
        case 7:
            let cell = table.dequeueReusableCell(withIdentifier: multiSelectionCell, for: indexPath) as! MultiInputCell
            cell.mainLabel.text = "Tillagning"
            cell.footerLabel.text = "\(howToAdded.count) tillagda"
            return cell
        default:
            let cell = table.dequeueReusableCell(withIdentifier: multiSelectionCell, for: indexPath) as! MultiInputCell
            cell.mainLabel.text = "Tillagning"
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 4:
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
                
            present(imagePicker, animated: true, completion: nil)
            
            
            print("")
//            let alert = UIAlertController(title: "ReceptFoto", message: "Välj ett foto från ditt bibliotek", preferredStyle: .alert)
//            let saveAction = UIAlertAction(title: "Välj", style: .default) { action in
//
//            }
//            let cancelAction = UIAlertAction(title: "Avbryt", style: .cancel)
//            alert.addAction(cancelAction)
//            alert.addAction(saveAction)
//            present(alert, animated: true)
            
        case 5:
            performSegue(withIdentifier: addTagsSegue, sender: self)
        case 6:
            performSegue(withIdentifier: addIngredientsSegue, sender: self)
        case 7:
            performSegue(withIdentifier: addHowToSegue, sender: self)
        default:
            print("")
        }
    }
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageTemp = pickedImage
        }

        dismiss(animated: true, completion: nil)
        self.table.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        table.reloadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addTagsSegue {
            guard let destinationVC = segue.destination as? AddTagsViewController else {return}
            destinationVC.newRecipeVC = self
            destinationVC.selectionsArray = tagsAdded 
        } else if segue.identifier == addIngredientsSegue {
            guard let destinationVC = segue.destination as? AddIngredientsViewController else {return}
            destinationVC.newRecipeVC = self
            destinationVC.ingredientsAdded = ingredientsAdded
            destinationVC.ingredientsAmountAdded = ingredientsAmountAdded
            destinationVC.ingredientsTypeAdded = ingredientsTypeAdded
        } else if segue.identifier == addHowToSegue {
            guard let destinationVC = segue.destination as? AddHowToViewController else {return}
            destinationVC.newRecipeVC = self
            destinationVC.howToAdded = howToAdded
        }
    }
    

}
