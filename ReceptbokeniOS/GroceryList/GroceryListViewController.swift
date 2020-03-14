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
        return groceries.groceryList.count
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
        }
        
        return returnCell
    }

}
