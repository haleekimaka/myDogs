//
//  AddDogViewControllerDelegate.swift
//  myDogs
//
//  Created by Arin Halicki on 1/31/18.
//  Copyright © 2018 Arin Halicki. All rights reserved.
//

import UIKit

protocol AddDogViewControllerDelegate: class {
    
    func itemSaved(by controller: AddDogViewController, with name: String, breed: String, treat: String, photo: Data, update: Bool, at: NSIndexPath? )
    
    func cancelButtonPressed(by controller: AddDogViewController)
    
    func deleteRecord(by controller: AddDogViewController, with indexPath: NSIndexPath)
}
