//
//  Groceries.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-03-10.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import Foundation

struct Groceries {
    var groceryList: [String]
    var groceryAmountList: [Int]
    var groceryAmountType: [Int]
    
    var doneGroceries: [String]
    var doneAmount: [Int]
    var doneType: [Int]
    
    let ingredientAmountType: [String] = ["st", "tsk", "krm", "msk", "ml", "cl", "dl", "l", "mg", "g", "hg", "kg"]
    
    init(groceries: [String], amount: [Int], type: [Int], doneGroceries: [String], doneAmount: [Int], doneType: [Int]) {
        self.groceryList = groceries
        self.groceryAmountList = amount
        self.groceryAmountType = type
        self.doneGroceries = doneGroceries
        self.doneAmount = doneAmount
        self.doneType = doneType
    }
}
