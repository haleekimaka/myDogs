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
    
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var dogBreed: UITextField!
    @IBOutlet weak var dogTreat: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancelButtonPressed(by controller: AddPhotoViewController) {
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
    
}
