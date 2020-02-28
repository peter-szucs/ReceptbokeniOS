//
//  AddIngredientsViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-24.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class AddIngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var ingredAmount: UITextField!
    @IBOutlet weak var ingredTypePicker: UIPickerView!
    @IBOutlet weak var addOrEditLabel: UILabel!
    
    
    var newRecipeVC: NewRecipeViewController?
    var ingredientsAdded: [String] = []
    var ingredientsAmountAdded: [Int] = []
    var ingredientsTypeAdded: [Int] = []
    
    var isCurrentlyEditing: Bool = false
    var isEditingIndex: Int = 0
    
    let ingredientAmountType: [String] = ["st", "tsk", "krm", "msk", "ml", "cl", "dl", "l", "mg", "g", "hg", "kg"]
    
    var addedIngredientCell = "AddedIngredientCell"
    
    var ingredientTypePicked: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - Pickerview
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingredientAmountType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ingredientAmountType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(ingredientAmountType[row])
        ingredientTypePicked = row
        
        // save selected row
//        saveSelected(row: row)
    }
    
//    func saveSelected(row: Int) {
//        let defaults = UserDefaults.standard
//        defaults.set(row, forKey: userDefaultsRowKey)
//        defaults.synchronize()
//    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: addedIngredientCell, for: indexPath) as! AddedIngredientsTableViewCell
        
        cell.ingredientTitle.text = ingredientsAdded[indexPath.row]
        cell.ingredientAmount.text = "\(ingredientsAmountAdded[indexPath.row]) \(ingredientAmountType[ingredientsTypeAdded[indexPath.row]])"
        
        return cell
    }
    
    func refreshTableView() {
        table.reloadData()
    }
    
    func refreshInputs() {
        ingredientInput.text = ""
        ingredAmount.text = ""
        ingredTypePicker.selectRow(0, inComponent: 0, animated: false)
        ingredientInput.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Ta bort") { (action, view, completion) in
            self.ingredientsAdded.remove(at: indexPath.row)
            self.ingredientsAmountAdded.remove(at: indexPath.row)
            self.ingredientsTypeAdded.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .bottom)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "icons8-trash-can-50")
        action.backgroundColor = .red
        
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Ändra") { (action, view, completion) in
            self.ingredientInput.text = self.ingredientsAdded[indexPath.row]
            self.ingredAmount.text = String(self.ingredientsAmountAdded[indexPath.row])
            self.ingredTypePicker.selectRow(self.ingredientsTypeAdded[indexPath.row], inComponent: 0, animated: true)
            self.ingredientTypePicked = self.ingredientsTypeAdded[indexPath.row]
            self.isEditingIndex = indexPath.row
            self.isCurrentlyEditing = true
            self.addOrEditLabel.text = "Ändra"
            self.ingredientInput.becomeFirstResponder()
            
        
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "icons8-edit-50")
        action.backgroundColor = .blue
        
        return action
    }
    
    // MARK: - Add/Edit ingredient to list
    
    @IBAction func addIngredient(_ sender: UIButton) {
        guard let ingredient = ingredientInput.text else {return}
        if isCurrentlyEditing {
            addOrEditLabel.text = "Lägg till"
            isCurrentlyEditing = false
            addIngredient(ingredient: ingredient, isEditing: true)
            refreshTableView()
        } else {
            if !(compareStrings(compareString: ingredient)) {
                addIngredient(ingredient: ingredient, isEditing: false)
            } else {
                doubleIngredientAlert(ingredient: ingredient)
                refreshTableView()
            }
        }
//        refreshTableView()
    }
    
    // MARK: - General Functions
    
    func wrongInputAlert() {
        let alert = UIAlertController(title: "Varning", message: "Din mängd kan bara innehålla siffror!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok!", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func doubleIngredientAlert(ingredient: String) {
        let alert = UIAlertController(title: "Lika ingredienser!", message: "Det verkar redan finnas en ingrediens med samma namn. Vill du fortsätta ändå?", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Ja", style: .default) { action in
            self.addIngredient(ingredient: ingredient, isEditing: false)
        }
        let cancelAction = UIAlertAction(title: "Avbryt", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func compareStrings(compareString: String) -> Bool {
        var isEqual = false
        for ingredient in ingredientsAdded {
            if (ingredient == compareString) {
                isEqual = true
                break
            }
        }
        return isEqual
    }
    
    func addIngredient(ingredient: String, isEditing: Bool) {
        guard let amount = ingredAmount.text else {return}
        let amountToInt = Int(amount) ?? 0
        if !(amountToInt == 0) {
            if !isEditing {
                ingredientsAmountAdded.append(amountToInt)
                ingredientsAdded.append(ingredient)
                ingredientsTypeAdded.append(ingredientTypePicked)
            } else {
                ingredientsAmountAdded[isEditingIndex] = amountToInt
                ingredientsAdded[isEditingIndex] = ingredient
                ingredientsTypeAdded[isEditingIndex] = ingredientTypePicked
            }
            
            refreshInputs()
            refreshTableView()
        } else {
            wrongInputAlert()
            
        }
    }
    
    
    // MARK: - Save ingredientlist
    
    
    @IBAction func saveIngredients(_ sender: UIBarButtonItem) {
        newRecipeVC?.ingredientsAdded = ingredientsAdded
        newRecipeVC?.ingredientsAmountAdded = ingredientsAmountAdded
        newRecipeVC?.ingredientsTypeAdded = ingredientsTypeAdded
        newRecipeVC?.refresh()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
