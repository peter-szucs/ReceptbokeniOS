//
//  AddTagsViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-20.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase

class AddTagsViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var newRecipeVC: NewRecipeViewController?
    var db: Firestore!
    let tagsCellID = "TagsCellID"
    var tagsGeneralArray: [String]? = []
    var tagsRegionArray: [String]? = []
    var selectionsArray: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Taggar"
        db = Firestore.firestore()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        loadData {
            self.sortData()
            self.table.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            guard let number = tagsRegionArray?.count else {return 0}
            return number
        } else {
            guard let number = tagsGeneralArray?.count else {return 0}
            return number
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tagsCellID, for: indexPath)
//        var tagCompare: String = ""
        if indexPath.section == 0 {
            if let tag = tagsRegionArray?[indexPath.row] {
                cell.textLabel?.text = tag
//                tagCompare = tag
                if compareStrings(stringA: tag) {
                    cell.accessoryType = .checkmark
                }
            } else {
                print("Nothing found")
            }
            
         
        } else {
            if let tag = tagsGeneralArray?[indexPath.row] {
                cell.textLabel?.text = tag
//                tagCompare = tag
                if compareStrings(stringA: tag) {
                    cell.accessoryType = .checkmark
                }
            } else {
                print("Nothing found")
            }
        }
//        if compareStrings(stringA: tagCompare) {
//            cell.accessoryType = .checkmark
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Region"
        } else {
            return "General"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = table.cellForRow(at: indexPath)
            if let tag = tagsRegionArray?[indexPath.row] {
                if !(compareStrings(stringA: tag)) {
                    selectionsArray.append(tag)
                    cell?.accessoryType = .checkmark
                } else {
                    var tempArray: [String] = []
                    tempArray.append(tag)
                    selectionsArray = Array(Set(selectionsArray).subtracting(tempArray))
                    cell?.accessoryType = .none
                }
                
            } else {
                print("Error, something went wrong")
            }
        } else {
            let cell = table.cellForRow(at: indexPath)
            if let tag = tagsGeneralArray?[indexPath.row] {
                if !(compareStrings(stringA: tag)) {
                    selectionsArray.append(tag)
                    cell?.accessoryType = .checkmark
                } else {
                    var tempArray: [String] = []
                    tempArray.append(tag)
                    selectionsArray = Array(Set(selectionsArray).subtracting(tempArray))
                    cell?.accessoryType = .none
                }
            } else {
                print("Error, something went wrong")
            }
        }
    }
    
    // MARK: - Savebutton
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        newRecipeVC?.tagsAdded = selectionsArray
        newRecipeVC?.refresh()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Datahandling

    func loadData(completion: @escaping () -> ()) {
            let tagsRef = db.collection("Tags")

            tagsRef.addSnapshotListener() { (snapshot, error) in

                guard let documents = snapshot?.documents else {return}
                for document in documents {
                    let snap = TagsDataHandler(snapshot: document)
                    self.tagsGeneralArray = snap.generalTags
                    self.tagsRegionArray = snap.regionTags
                    
                }
            completion()
        }
    }
    
    func sortData() {
        tagsGeneralArray?.sort()
        tagsRegionArray?.sort()
    }
    
    func compareStrings(stringA: String) -> Bool {
        var isEqual = false
        for selectedTag in selectionsArray {
            if (selectedTag == stringA) {
                isEqual = true
                break
            }
        }
        return isEqual
    }
        
}
