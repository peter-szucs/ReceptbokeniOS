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
    
    var auth: Auth!
    var db: Firestore!
    
    var indexToSegue: Int = 0
    var menuItems: [MenuItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructMenuTable()
        let auth = Auth.auth()
        db = Firestore.firestore()
        guard let user = auth.currentUser else {return}
        auth.signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
//            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                print("Login is complete, userID: \(String(describing: uid))")
            }
//            let dbRef = self.db.collection("users").document(uid)
//            dbRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                } else {
//                    print("Document does not exist, creating new")
//                    self.db.collection("users").document(uid).setData( ["favorites" : [String]() ])
//                }
//            }
        }
        
        /*
        // TODO: - Fixa till så att users läggs till och att en collection med nedanstående läggs till.
        let itemRef = db.collection("users").document(user.uid).collection("isFavorite")
        */
        
    }
    
    func constructMenuTable() {
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "recipebook"), title: "Mina recept"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "favorites"), title: "Mina favoriter"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "addNewRecipe"), title: "Skapa nytt recept"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "cart"), title: "Inköpslista"))
        menuItems.append(MenuItems(icon: #imageLiteral(resourceName: "search"), title: "Sök recept"))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showRecipes {
            guard let destinationVC = segue.destination as? RecipesViewController else {return}
//            guard let cell = sender as? UITableViewCell else {return}
//            guard let indexPath = tableView.indexPath(for: indexToSegue) else {return}
            guard let nextVCTitle = menuItems[indexToSegue].title else {return}
            if (indexToSegue == 1) {
                destinationVC.filterForFav = true
            }
            if (indexToSegue == 4) {
                destinationVC.searchController.becomeFirstResponder()
            }
            
            destinationVC.pageTitle = nextVCTitle
        } else if (segue.identifier == newRecipe) {
            guard let destinationVC = segue.destination as? NewRecipeViewController else {return}
//            guard let cell = sender as? UITableViewCell else {return}
//            guard let indexPath = tableView.indexPath(for: indexToSegue) else {return}
            guard let nextVCTitle = menuItems[indexToSegue].title else {return}
            
            destinationVC.pageTitle = nextVCTitle
        }
    }
    
    // MARK: - TableView
    
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
            indexToSegue = indexPath.row
            performSegue(withIdentifier: showRecipes, sender: self)
        case 1:
            indexToSegue = indexPath.row
            performSegue(withIdentifier: showRecipes, sender: self)
        case 2:
            indexToSegue = indexPath.row
            performSegue(withIdentifier: newRecipe, sender: self)
        case 3:
            indexToSegue = indexPath.row
            print("Coming Soon")
//            performSegue(withIdentifier: groceryList, sender: self)
        case 4:
            indexToSegue = indexPath.row
            performSegue(withIdentifier: showRecipes, sender: self)
            
        default:
            print("Nothing happened")
        }
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
    
    @IBAction func unwindToVC1(_ sender: UIStoryboardSegue) { }
    
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

