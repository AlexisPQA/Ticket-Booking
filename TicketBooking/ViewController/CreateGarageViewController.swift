//
//  CreateGarageViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 1/11/21.
//

import Foundation
import UIKit
import Firebase

class CreateGarageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var garageNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var openTimeTextField: UITextField!
    @IBOutlet weak var ticketPriceTextField: UITextField!
    @IBOutlet weak var utilitiesTextField: UITextField!
    @IBOutlet weak var sellersTableView: UITableView!
    @IBOutlet weak var sellerEmailTextField: UITextField!
    @IBOutlet weak var addSellerButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    var station = BusStation()
    var listOfManager : [User] = []

    var db : Firestore!
    let storage = Storage.storage()
    
    override func viewWillAppear(_ animated: Bool) {
        sellersTableView.contentSize.height = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create garage"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(createGarageSuccessfully))
        
        sellersTableView.delegate = self
        sellersTableView.dataSource = self
    }
    
    @objc func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Every cell is 30 of height
        tableView.contentSize.height = CGFloat(listOfManager.count * 30)
        return listOfManager.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sellerTableViewCell") as! SellerTableViewCell
        cell.sellerNameLabel.text = listOfManager[indexPath.row].name
        cell.deleteCellButton.tag = indexPath.row
        cell.deleteCellButton.addTarget(self, action: #selector(deleteRowAt(sender:)), for: .touchUpInside)
        return cell
    }
    
    //This function delete row at index on tableView
    @objc func deleteRowAt(sender: UIButton) {
        let index = sender.tag
        listOfManager.remove(at: index)
        sellersTableView.reloadData()
    }
    
    @IBAction func addManagerTouched(_ sender: Any) {
        //Get email from textfield
        let email = sellerEmailTextField.text!
        
        //Use email to find account on Firebase
        db.collection("users").document(email).getDocument() { (document, error) in
          if let document = document, document.exists {
            let user = User(document: document)
            self.listOfManager.append(user)
            self.sellersTableView.reloadData()
          } else {
            let alert = UIAlertController(title: "Account does not exist", message: "This email does not exist in the system.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
          }
        }
    }
    
    @objc func createGarageSuccessfully() {
        var listOfEmail : [String] = []
        for i in listOfManager {
            listOfEmail.append(i.email)
            db.collection("users").document(i.email).updateData([ "permission": 2 ])
        }
        
        if ((garageNameTextField.text != nil) && (addressTextField.text != nil) && (openTimeTextField.text != nil) && listOfManager.count > 0) {
            
            let newGarage = Garage(id: "", address: addressTextField.text ?? "", busStation: station.id, name: garageNameTextField.text ?? "", openTime: openTimeTextField.text ?? "", ticketPrice: ticketPriceTextField.text ?? "", rating: 4.0, manager: listOfEmail)
            
            // Upload newGarage to Firebase
            do {
                // Endcode
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(newGarage)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
//                db.collection("Garage").document(newGarage.id).setData(json)
                var ref: DocumentReference? = nil
                ref = db.collection("Garage").addDocument(data: json) { err in
                    if let err = err {
                        let alert = UIAlertController(title: "Upload garage unsuccessfully", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        self.db.collection("Garage").document(ref!.documentID).updateData([ "id": "\(ref!.documentID)" ])
                    }
                }
            } catch let error {
                let alert = UIAlertController(title: "Upload garage unsuccessfully", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            // Upload garageImage to Firebse Storage
            let garageImage = thumbnail.image?.jpegData(compressionQuality: 10.0)
            let storageRef = storage.reference().child("Garage/\(newGarage.id)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.putData(garageImage!, metadata: metaData) { (metaData, error) in
                if let err = error {
                    let alert = UIAlertController(title: "Upload image unsuccessfully", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Upload garageImage successfully!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Create garage unsuccessfully", message: "Please fill in fields which have (*) signal.\n The Garage have at least a manager.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
//    // Create id from name
//    func createGarageId(name: String) -> String {
//
//        var str : String = name
//        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
//        var sID = String(str[str.index(str.startIndex, offsetBy: 0)])
//        for i in 1...(str.count - 1) {
//            if str[str.index(str.startIndex, offsetBy: (i - 1))] == " " {
//                sID = "\(sID)\(String(str[str.index(str.startIndex, offsetBy: (i - 1))]))"
//            }
//        }
//
//        var s = sID
//        var count = 0
//        for id in getAllIdGarage() {
//            if id == s {
//                count += 1
//                s = "\(sID)\(count)"
//            }
//        }
//        print("Your ID: \(sID)")
//        return sID
//    }
//
//    func getAllIdGarage() -> [String] {
//        var result : [String] = []
//        db.collection("Garage").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    result.append(document.documentID)
//                }
//            }
//        }
//        return result
//    }

    @IBAction func addImageTouched(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.dismiss(animated: true, completion: nil)
            self.thumbnail.image = image
            self.addImageButton.setTitle("Change Photo", for: .normal)
        }
    }
}

class SellerTableViewCell : UITableViewCell {
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var deleteCellButton: UIButton!
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            print("Can't find camera.")
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }


    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
