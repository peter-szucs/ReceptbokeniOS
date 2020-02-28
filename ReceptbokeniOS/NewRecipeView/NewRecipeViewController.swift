//
//  NewRecipeViewController.swift
//  ReceptbokeniOS
//
//  Created by Peter Szücs on 2020-02-18.
//  Copyright © 2020 Peter Szücs. All rights reserved.
//

import UIKit
import Firebase

class NewRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var db: Firestore!
    
    let imagePicker = UIImagePickerController()
    var imageTemp: UIImage?
    var randomImageID: String = ""
    
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
    let newRecipeSavedSegue = "NewRecipeSavedSegue"
    
    var tagsAdded: [String] = []
    var ingredientsAdded: [String] = []
    var ingredientsAmountAdded: [Int] = []
    var ingredientsTypeAdded: [Int] = []
    var howToAdded: [String] = []
    var timeStringAdded: String = ""
    
    var randomRecipeID: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        db = Firestore.firestore()
        
        
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
        } else if segue.identifier == newRecipeSavedSegue {
            guard let destinationVC = segue.destination as? RecipeContentViewController else {return}
            newRecipe?.recipeIDString = randomRecipeID
            let nextVCRecipe = newRecipe
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            destinationVC.comingFromNewRecipe = true
            destinationVC.theRecipe = nextVCRecipe
        }
    }
    
    // MARK: - Save Button
    
    @IBAction func saveNewRecipeButton(_ sender: UIBarButtonItem) {
        setRecipe()
        let dataBaseRef = db.collection("Recipes")
        
        if let recipeUploadRef = newRecipe {
            let randomRecipeID = UUID.init().uuidString
            dataBaseRef.document(randomRecipeID).setData(recipeUploadRef.toDictionary())
            uploadPhoto(imageID: randomImageID) {
                self.performSegue(withIdentifier: self.newRecipeSavedSegue, sender: self)
            }
        } else {
            incompleteRecipeAlert()
        }
    }
    
    // MARK: - Functions
    
    func refresh() {
        table.reloadData()
    }
    
    func uploadPhoto(imageID: String, completion: @escaping () -> ()) {
        
        let uploadRef = Storage.storage().reference(withPath: "images/\(imageID).jpg")
        guard let imageData = imageTemp?.jpegData(compressionQuality: 0.25) else {return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                print("Put is complete and i got this back: \(String(describing: downloadMetaData))")
                completion()
            }
        }
    }
    
    func setRecipe() {
        var singleInputTempArray: [String] = []
        for index in 0...2 {
            let indexPath = IndexPath(row: index, section: 0)
            let cell: SingleInputCell = table.cellForRow(at: indexPath) as! SingleInputCell
            if let input = cell.inputField.text {
                singleInputTempArray.append(input)
            } else {
                print("Empty")
            }
        }
        setTimeString()
        let portionsToInt = Int(singleInputTempArray[1]) ?? 0
        if portionsToInt == 0 {
            let alert = UIAlertController(title: "Fel inmatning", message: "Antal portioner verkar vara fel!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            if !(ingredientsAdded.count == 0 || tagsAdded.count == 0 || howToAdded.count == 0) {
                randomImageID = UUID.init().uuidString
                let uploadRecipe = Recipe(title: singleInputTempArray[0], imageID: "\(randomImageID).jpg", author: singleInputTempArray[2], portions: portionsToInt, time: timeStringAdded, tags: tagsAdded, ingredients: ingredientsAdded, ingredAmount: ingredientsAmountAdded, ingredType: ingredientsTypeAdded, howTo: howToAdded)
                newRecipe = uploadRecipe
            } else {
                incompleteRecipeAlert()
            }
        }
        
    }
    
    func setTimeString() {
        let indexPath = IndexPath(row: 3, section: 0)
        let cell: CookTimeInputCell = table.cellForRow(at: indexPath) as! CookTimeInputCell
        guard let hour = cell.hourInput.text else {return}
        guard let minute = cell.minuteInput.text else {return}
        let hourToInt = Int(hour) ?? 0
        let minuteToInt = Int(minute) ?? 0
        if (hourToInt == 0 && minuteToInt == 0) {
            let alert = UIAlertController(title: "Varning", message: "Tillagningstiden är ej ifylld, eller fel ifylld.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            if hourToInt == 0 {
                timeStringAdded = "\(minuteToInt) min"
            } else if !(hourToInt == 0) {
                if minuteToInt == 0 {
                    timeStringAdded = "\(hourToInt) h"
                } else if !(minuteToInt == 0) {
                    timeStringAdded = "\(hourToInt) h \(minuteToInt) min"
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    func incompleteRecipeAlert() {
    let alert = UIAlertController(title: "Varning", message: "Ditt recept verkar ej vara komplett. Kolla igenom så du fyllt i allt!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
//    @IBAction func debubButton(_ sender: Any) {
//        setRecipe()
//        print(newRecipe?.toDictionary())
//    }
    
//    StorageReference childRef2 = [your firebase storage path]
//    storageRef.child(UserDetails.username+"profilepic.jpg");
//    Bitmap bmp = MediaStore.Images.Media.getBitmap(getContentResolver(), filePath);
//    ByteArrayOutputStream baos = new ByteArrayOutputStream();
//    bmp.compress(Bitmap.CompressFormat.JPEG, 25, baos);
//    byte[] data = baos.toByteArray();
//    //uploading the image
//    UploadTask uploadTask2 = childRef2.putBytes(data);
//    uploadTask2.addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
//        @Override
//        public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
//            Toast.makeText(Profilepic.this, "Upload successful", Toast.LENGTH_LONG).show();
//        }
//    }).addOnFailureListener(new OnFailureListener() {
//        @Override
//        public void onFailure(@NonNull Exception e) {
//            Toast.makeText(Profilepic.this, "Upload Failed -> " + e, Toast.LENGTH_LONG).show();
//        }
//    });`
    
    
    
}
