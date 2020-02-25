//
//  ViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-03.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainMenuCell = "MainMenuCell"
    let showRecipes = "ShowRecipes"
    let newRecipe = "NewRecipe"
//    let storage = Storage.storage()
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems: [MenuItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructMenuTable()
        
    }
    
    func constructMenuTable() {
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "recipebook"), title: "Mina sparade recept"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "favorites"), title: "Mina favoriter"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "addNewRecipe"), title: "Skapa nytt recept"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "cart"), title: "Inköpslista"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "search"), title: "Sök recept"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showRecipes {
            guard let destinationVC = segue.destination as? RecipesViewController else {return}
            guard let cell = sender as? UITableViewCell else {return}
            guard let indexPath = tableView.indexPath(for: cell) else {return}
            guard let nextVCTitle = menuItems[indexPath.row].title else {return}
            
            destinationVC.pageTitle = nextVCTitle
        } else if (segue.identifier == newRecipe) {
            guard let destinationVC = segue.destination as? NewRecipeViewController else {return}
            guard let cell = sender as? UITableViewCell else {return}
            guard let indexPath = tableView.indexPath(for: cell) else {return}
            guard let nextVCTitle = menuItems[indexPath.row].title else {return}
            destinationVC.pageTitle = nextVCTitle
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: mainMenuCell, for: indexPath) as! MainMenuCell
        cell.setMenu(menu: menu)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: showRecipes, sender: self)
        case 1:
            performSegue(withIdentifier: showRecipes, sender: self)
        case 2:
            performSegue(withIdentifier: newRecipe, sender: self)
        case 3:
            print("Coming Soon")
//            performSegue(withIdentifier: groceryList, sender: self)
        case 4:
            performSegue(withIdentifier: showRecipes, sender: self)
            
        default:
            print("Nothing happened")
        }
        
//        print("Selected: \(menuItems[indexPath.row].title!)")
    }

    @IBAction func uploadImage(_ sender: UIButton) {
//        let randomID = UUID.init().uuidString
//        let uploadRef = Storage.storage().reference(withPath: "images/\(randomID).jpg")
//        guard let imageData = #imageLiteral(resourceName: "carbonaraPic").jpegData(compressionQuality: 0.75) else {return}
//        let uploadMetaData = StorageMetadata.init()
//        uploadMetaData.contentType = "image/jpeg"
//
//        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            } else {
//                print("Put is complete and i got this back: \(String(describing: downloadMetaData))")
//            }
//        }
        print("Nothing Happened")
    }
    
}

// Hide keyboard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

