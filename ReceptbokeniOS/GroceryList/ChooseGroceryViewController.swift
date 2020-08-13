//
//  ChooseGroceryViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-03-10.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class ChooseGroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    
    let groceryListCellID = "GroceryListCellID"
    let groceryListSegueID = "GroceryListSegueID"
    
    let ingredientAmountType: [String] = ["st", "tsk", "krm", "msk", "ml", "cl", "dl", "l", "mg", "g", "hg", "kg"]
    var groceryList: [String] = []
    var groceryTypeList: [Int] = []
    var groceryAmountList: [Int] = []
    var groceries: Groceries?
    var addedGroceriesArrayIndex: [Int] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        groceries = Groceries(groceries: groceryList, amount: groceryAmountList, type: groceryTypeList, doneGroceries: [], doneAmount: [], doneType: [])
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == groceryListSegueID {
            guard let destinationVC = segue.destination as? GroceryListViewController else {return}
            guard let segueGroceries = groceries else {return}
            destinationVC.groceries = segueGroceries
        }
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: groceryListCellID, for: indexPath)
        let tempType = groceryTypeList[indexPath.row]
        let tempString = "\(groceryAmountList[indexPath.row]) \(ingredientAmountType[tempType])"
        cell.textLabel?.text = groceryList[indexPath.row]
        cell.detailTextLabel?.text = tempString
        cell.accessoryType = .checkmark
        if doesItExist(indexPath: indexPath.row) {
            cell.tintColor = .black
            cell.backgroundColor = .systemTeal
        } else {
            cell.tintColor = .white
            cell.backgroundColor = .white
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        if !(doesItExist(indexPath: indexPath.row)) {
            addedGroceriesArrayIndex.append(indexPath.row)
//            cell?.accessoryType = .checkmark
            cell?.backgroundColor = .systemTeal
            cell?.tintColor = .black
            addedGroceriesArrayIndex.sort()
            print(addedGroceriesArrayIndex)
        } else {
            var tempArray: [Int] = []
            tempArray.append(indexPath.row)
            addedGroceriesArrayIndex = Array(Set(addedGroceriesArrayIndex).subtracting(tempArray))
//            cell?.accessoryType = .none
//            cell?.backgroundView?.backgroundColor = .white
            cell?.tintColor = .white
            cell?.backgroundColor = .white
            print(addedGroceriesArrayIndex)
        }
    }
    
    // MARK: - Functions
    
    func doesItExist(indexPath: Int) -> Bool {
        for addedGrocery in addedGroceriesArrayIndex {
            if addedGrocery == indexPath {
                return true
            }
        }
        return false
    }
    
    func addAllToArray() {
        var counter = 0
        for _ in groceryList {
            addedGroceriesArrayIndex.append(counter)
            counter += 1
        }
        print(addedGroceriesArrayIndex)
    }
    
    func setGroceriesForSegue() {
        var tempGroceries: [String] = []
        var tempGroceryAmount: [Int] = []
        var tempGroceryAmountType: [Int] = []
        for i in addedGroceriesArrayIndex {
            tempGroceries.append(groceryList[addedGroceriesArrayIndex[i]])
            tempGroceryAmount.append(groceryAmountList[addedGroceriesArrayIndex[i]])
            tempGroceryAmountType.append(groceryTypeList[addedGroceriesArrayIndex[i]])
        }
        groceries?.groceryList = tempGroceries
        groceries?.groceryAmountList = tempGroceryAmount
        groceries?.groceryAmountType = tempGroceryAmountType
    }
    
    // MARK: - Buttons
    
    @IBAction func addAll(_ sender: UIButton) {
        addedGroceriesArrayIndex.removeAll()
        addAllToArray()
        table.reloadData()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
    }
    
    
    
}
