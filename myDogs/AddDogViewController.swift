//
//  AddDogViewController.swift
//  myDogs
//
//  Created by Arin Halicki on 1/29/18.
//  Copyright © 2018 Arin Halicki. All rights reserved.
//

import UIKit
import CoreData

class AddDogViewController: UIViewController, AddPhotoViewControllerDelegate {
    
    weak var delegate: AddDogViewControllerDelegate?
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var dogBreed: UITextField!
    @IBOutlet weak var dogTreat: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var pickedImage: UIImage?
    var compressedImageData: Data!
    var sentData: DogRecord!
    var updating: Bool = false
    
    var indexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredLabel.isHidden = true
        dogName.text = sentData?.name
        dogBreed.text = sentData?.breed
        dogTreat.text = sentData?.treat
        
        if let photo = sentData?.photo {
            pickedImage = UIImage(data: photo)
            compressedImageData = photo
            addPhotoButton.setBackgroundImage(pickedImage, for: .normal)
        }
        if updating == true {
            deleteButton.isHidden = false
            addPhotoButton.setTitle("Change Photo", for: .normal)
            viewLabel.text = "Edit Dog"
        }
        else {
            deleteButton.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        updating = false
        delegate?.cancelButtonPressed(by: self)
        
    }
    func cancelButtonPressed(by controller: AddPhotoViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func useThisPhotoButtonPressed(by controller: AddPhotoViewController, with image: UIImage) {
        pickedImage = image
        let compressedImage = resize(image)
    addPhotoButton.setBackgroundImage(compressedImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dogName.resignFirstResponder()
        dogBreed.resignFirstResponder()
        dogTreat.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! AddPhotoViewController
            destination.delegate = self
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if dogName.text == "" {
            requiredLabel.isHidden = false
        }
        else if dogBreed.text == "" {
            requiredLabel.isHidden = false
        }
        else if dogTreat.text == "" {
            requiredLabel.isHidden = false
        }
        else if compressedImageData == nil {
            requiredLabel.isHidden = false
        }
        else {
            delegate?.itemSaved(by: self, with: dogName.text!, breed: dogBreed.text!, treat: dogTreat.text!, photo: compressedImageData, update: updating, at: indexPath )
        }
        updating = false
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        delegate?.deleteRecord(by: self, with: indexPath)
    }
    
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: CGFloat = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        UIGraphicsEndImageContext()
        compressedImageData = imageData
        return UIImage(data: imageData!) ?? UIImage()
    }
    
}
