//
//  NewRestaurantController.swift
//  FoodPie
//
//  Created by 黄小净 on 2020/4/13.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit
import CloudKit

class NewRestaurantController: UITableViewController,UITextFieldDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextField: UITextView! {
        didSet {
            descriptionTextField.tag = 5
            descriptionTextField.layer.cornerRadius = 5.0
            descriptionTextField.layer.masksToBounds = true
        }
    }
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
        }
        
        tableView.separatorStyle = .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag( textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let sheetController = UIAlertController(title: "", message: NSLocalizedString("Choose your phone source", comment: "Choose your phone source"), preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: {
                action in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let impagePicker = UIImagePickerController()
                    impagePicker.allowsEditing = false
                    impagePicker.sourceType = .camera
                    impagePicker.delegate = self
                    
                    self.present(impagePicker, animated: true, completion: nil)
                }
                
            })
            
            let photoLibraryAction = UIAlertAction(title: NSLocalizedString("PhotoLibrary", comment: "PhotoLibrary"), style: .default, handler: {
                action in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            if let popoverController = sheetController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            sheetController.addAction(cameraAction)
            sheetController.addAction(photoLibraryAction)
            self.present(sheetController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photoImageView.image = selectImage
            self.photoImageView.contentMode = .scaleAspectFill
            self.photoImageView.clipsToBounds = true
            
            let photoImageViewLeading = NSLayoutConstraint(item: self.photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
            photoImageViewLeading.isActive = true
            
            let photoImageViewTop = NSLayoutConstraint(item: self.photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
            photoImageViewTop.isActive = true
            
            let photoImageViewTrailing = NSLayoutConstraint(item: self.photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
            photoImageViewTrailing.isActive = true
            
            let photoImageViewBottom = NSLayoutConstraint(item: self.photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
            photoImageViewBottom.isActive = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonOnTap(sender: AnyObject) {
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("Oops", comment: "Oops"), message: NSLocalizedString("We can't proceed because one of fields is blank. Please note that all fields are required.", comment: "We can't proceed because one of fields is blank. Please note that all fields are required."), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = addressTextField.text
            restaurant.phone = phoneTextField.text
            restaurant.summary = descriptionTextField.text
            restaurant.isVisited = false
            
            if let restaurantImage = photoImageView.image {
                restaurant.image = restaurantImage.pngData()
            }
            
            print("正在保存数据中....")
            appDelegate.saveContext()
        }

        saveRecordToCloud(restaurant: restaurant)

        dismiss(animated: true, completion: nil)
    }

    func saveRecordToCloud(restaurant: RestaurantMO) {
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.summary, forKey: "description")

        let imageData = restaurant.image! as Data
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? scaledImage?.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)

        let iamgeAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(iamgeAsset, forKey: "image")

        let publicDatabase = CKContainer(identifier: "").publicCloudDatabase
        publicDatabase.save(record, completionHandler: {(record, error) -> Void in
            if let error = error {
                print("upload data error: \(error)")
                return
            }

            try? FileManager.default.removeItem(at: imageFileURL)
        })
    }
}
