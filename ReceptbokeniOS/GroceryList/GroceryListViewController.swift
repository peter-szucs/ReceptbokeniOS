//
//  GroceryListViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-03-10.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var activeGroceriesTable: UITableView!
    
    @IBOutlet weak var doneGroceriesTable: UITableView!
    
    let activeGroceriesCellID = "ActiveGroceriesCellID"
    let doneGroceriesCellID = "DoneGroceriesCellID"
    
    var groceries = Groceries(groceries: [], amount: [], type: [], doneGroceries: [], doneAmount: [], doneType: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeGroceriesTable.delegate = self
        activeGroceriesTable.dataSource = self
        doneGroceriesTable.delegate = self
        doneGroceriesTable.dataSource = self

    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let nrOfActiveGroceries = groceries.groceryList.count else {return 0}
//        return nrOfActiveGroceries
        if tableView == activeGroceriesTable {
            return groceries.groceryList.count
        } else {
            return groceries.doneGroceries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == activeGroceriesTable {
            let cell = activeGroceriesTable.dequeueReusableCell(withIdentifier: activeGroceriesCellID, for: indexPath)
            cell.textLabel?.text = groceries.groceryList[indexPath.row]
            cell.detailTextLabel?.text = "\(groceries.groceryAmountList[indexPath.row]) \(groceries.ingredientAmountType[groceries.groceryAmountType[indexPath.row]])"
//            cell.textLabel?.text = groceries?.groceryList[indexPath.row]
//            if let tempType = groceries?.groceryAmountType[indexPath.row] {
//                guard let tempAmount = groceries?.groceryAmountList[indexPath.row]
//                cell.detailTextLabel?.text = "\(groceries?.groceryAmountList[indexPath.row])) \(groceries?.ingredientAmountType[tempType]))"
//            } else {
//                print("Error")
//            }
            
            returnCell = cell
        } else {
            let cell = doneGroceriesTable.dequeueReusableCell(withIdentifier: doneGroceriesCellID, for: indexPath)
            cell.textLabel?.text = groceries.doneGroceries[indexPath.row]
            cell.detailTextLabel?.text = "\(groceries.doneAmount[indexPath.row]) \(groceries.ingredientAmountType[groceries.doneType[indexPath.row]])"
            returnCell = cell
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == activeGroceriesTable {
            var tempArray: [String] = []
            var tempAmountArray: [Int] = []
            var tempTypeArray: [Int] = []
            tempArray.append(groceries.groceryList[indexPath.row])
            tempAmountArray.append(groceries.groceryAmountList[indexPath.row])
            tempTypeArray.append(groceries.groceryAmountType[indexPath.row])
            
            groceries.doneGroceries.append(groceries.groceryList[indexPath.row])
            groceries.groceryList.remove(at: indexPath.row)
            groceries.doneAmount.append(groceries.groceryAmountList[indexPath.row])
            groceries.groceryAmountList.remove(at: indexPath.row)
            groceries.doneType.append(groceries.groceryAmountType[indexPath.row])
            groceries.groceryAmountType.remove(at: indexPath.row)
            refreshTables()
            
//            groceries.doneGroceries.append(groceries.groceryList[indexPath.row])
//            groceries.groceryList = Array(Set(groceries.groceryList).subtracting(tempArray))
//            groceries.doneAmount.append(groceries.groceryAmountList[indexPath.row])
//            groceries.groceryAmountList = Array(Set(groceries.groceryAmountList).subtracting(tempAmountArray))
//            groceries.doneType.append(groceries.groceryAmountType[indexPath.row])
//            groceries.groceryAmountType = Array(Set(groceries.groceryAmountType).subtracting(tempTypeArray))
//            refreshTables()
        } else {
            var tempArray: [String] = []
            var tempAmountArray: [Int] = []
            var tempTypeArray: [Int] = []
            tempArray.append(groceries.doneGroceries[indexPath.row])
            tempAmountArray.append(groceries.doneAmount[indexPath.row])
            tempTypeArray.append(groceries.doneType[indexPath.row])
            
            groceries.groceryList.append(groceries.doneGroceries[indexPath.row])
            groceries.doneGroceries.remove(at: indexPath.row)
            groceries.groceryAmountList.append(groceries.doneAmount[indexPath.row])
            groceries.doneAmount.remove(at: indexPath.row)
            groceries.groceryAmountType.append(groceries.doneType[indexPath.row])
            groceries.doneType.remove(at: indexPath.row)
            
            
//            groceries.doneGroceries = Array(Set(groceries.doneGroceries).subtracting(tempArray))
//            groceries.groceryList.append(groceries.doneGroceries[indexPath.row])
//            groceries.doneAmount = Array(Set(groceries.doneAmount).subtracting(tempAmountArray))
//            groceries.groceryAmountList.append(groceries.doneAmount[indexPath.row])
//            groceries.doneType = Array(Set(groceries.doneType).subtracting(tempTypeArray))
//            groceries.groceryAmountType.append(groceries.doneType[indexPath.row])
            refreshTables()
        }
    }
    
    func refreshTables() {
        activeGroceriesTable.reloadData()
        doneGroceriesTable.reloadData()
    }

}
