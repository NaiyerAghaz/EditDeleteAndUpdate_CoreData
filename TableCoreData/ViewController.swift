//
//  ViewController.swift
//  TableCoreData
//
//  Created by Naiyer on 23/07/19.
//  Copyright © 2019 Naiyer. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var name: UITextField!
    var updateImg: NSData?
    var updateName = ""
    var updateAge = ""
    var updateDob = ""
    var updateDesignation = ""
    var updateId = 0
    var isUpdates = false
    var imagePicker = UIImagePickerController()
    var user: [NSManagedObject] = []
    var usersId:Int = 0
    
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdates {
            userImage.image = UIImage(data: updateImg! as Data)
            btnSave.setTitle("Update", for: .normal)
            designation.text = updateDesignation
            dob.text = updateDob
            age.text = updateAge
            name.text = updateName
        }
        self.hideKeyboardWhenTappedAround()
        userImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:#selector(getImageFromPicker(_:)))
        userImage.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let manageContainer = appdelegate.persistentContainer.viewContext
        if check(forBlanks: name) {
            showAlert(withTitleMessageAndAction: "Alert", message: "Please fill the user name", action: false)
        }
        else if check(forBlanks: age) {
            showAlert(withTitleMessageAndAction: "Alert", message: "Please fill age", action: false)
        }
        else if check(forBlanks: dob) {
            showAlert(withTitleMessageAndAction: "Alert", message: "Please fill dob", action: false)
        }
        else if check(forBlanks: designation) {
            showAlert(withTitleMessageAndAction: "Alert", message: "Please fill designation", action: false)
        }
        else if isUpdates {
            let entity = NSEntityDescription.entity(forEntityName: "TableData", in: manageContainer)
            let req = NSFetchRequest<NSFetchRequestResult>()
            req.entity = entity
            let predicate = NSPredicate(format: "id = %d", updateId)
            req.predicate = predicate
            do {
                let result  = try manageContainer.fetch(req)
                let objUpdate = result[0] as! NSManagedObject
                objUpdate.setValue(name.text, forKey: "userName")
                 objUpdate.setValue(dob.text, forKey: "userDOB")
                 objUpdate.setValue(age.text, forKey: "userAge")
                 objUpdate.setValue(designation.text, forKey: "userDesignation")
                let image = userImage.image!
                let imageData = image.jpegData(compressionQuality: 0.50)
               
                objUpdate.setValue(imageData, forKey: "userImg")
                do {
                    try manageContainer.save()
                    showAlert(withTitleMessageAndAction: "Alerts", message: "Successfully updated", action: true)
                }
                catch {
                    print(error)
                }
                
            }
            catch _{
                
            }
            
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "TableData", in: manageContainer)
            
            let users = NSManagedObject(entity: entity!, insertInto: manageContainer)
            let tbliD = usersId + 1
            users.setValue(tbliD, forKey: "id")
            users.setValue(name.text, forKey: "userName")
            users.setValue(dob.text, forKey: "userDOB")
            users.setValue(age.text, forKey: "userAge")
            users.setValue(designation.text, forKey: "userDesignation")
            let image = userImage.image!
            let imageData = image.jpegData(compressionQuality: 0.50)
            
            users.setValue(imageData, forKey: "userImg")
            do {
                try manageContainer.save()
                showAlert(withTitleMessageAndAction: "Alerts", message: "Successfully updated", action: true)
            }
            catch {
                print(error)
            }
        }
        }
    @objc func getImageFromPicker(_ sender: UITapGestureRecognizer){
        let alertCont = UIAlertController(title: "Alert", message: "Please choose the sources", preferredStyle: .actionSheet)
        alertCont.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
                self.showAlert(withTitleMessageAndAction: "Alert", message: "Camera is not available", action: false)
            }
        }))
        alertCont.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                self.showAlert(withTitleMessageAndAction: "Alert", message: "Photo Library is not available", action: false)
            }
            
        }))
        present(alertCont, animated: true, completion: nil)
        
    }
    func showAlert(withTitleMessageAndAction title:String, message:String , action: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if action {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        } else{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgInfo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.image = imgInfo
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //Other methods
    // MARK: – Other Methods.
    func check(forBlanks textfield: UITextField) -> Bool {
        let rawString: String? = textfield.text
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed: String? = rawString?.trimmingCharacters(in: whitespace)
        if (trimmed?.count ?? 0) == 0 {
            return true
        }
        else {
            return false
        }
    }
}
