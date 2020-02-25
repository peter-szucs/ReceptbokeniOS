//
//  AddHowToViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-25.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class AddHowToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputField: UITextView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addOrEditLabel: UILabel!
    
    
    var newRecipeVC: NewRecipeViewController?
    var howToCellID = "HowToCellID"
    var howToAdded: [String] = []
    var isCurrentlyEditing: Bool = false
    var isEditingIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        inputField.becomeFirstResponder()
        inputField.layer.borderWidth = 1.0
        inputField.layer.cornerRadius = 5.0
        inputField.layer.borderColor = UIColor.lightGray.cgColor
        self.hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return howToAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: howToCellID, for: indexPath)
        cell.textLabel?.text = howToAdded[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Ta bort") { (action, view, completion) in
            self.howToAdded.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .bottom)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "icons8-trash-can-50")
        action.backgroundColor = .red
        
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Ändra") { (action, view, completion) in
            self.inputField.text = self.howToAdded[indexPath.row]
            self.isEditingIndex = indexPath.row
            self.isCurrentlyEditing = true
            self.addOrEditLabel.text = "Ändra"
            self.inputField.becomeFirstResponder()
            
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "icons8-edit-50")
        action.backgroundColor = .green
        
        return action
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            howToAdded.remove(at: indexPath.row)
//            table.deleteRows(at: [indexPath], with: .bottom)
//        } else if editingStyle == .insert {
//            inputField.text = howToAdded[indexPath.row]
//            inputField.becomeFirstResponder()
//        }
//    }
    
    // MARK: - Buttons
    
    @IBAction func addNewButton(_ sender: UIButton) {
        if isCurrentlyEditing {
            howToAdded[isEditingIndex] = inputField.text
            addOrEditLabel.text = "Lägg till"
        } else {
            howToAdded.append(inputField.text)
        }
        table.reloadData()
        inputField.text = ""
        inputField.becomeFirstResponder()
    }
    
    @IBAction func saveHowToButton(_ sender: UIBarButtonItem) {
        newRecipeVC?.howToAdded = howToAdded
        newRecipeVC?.refresh()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

