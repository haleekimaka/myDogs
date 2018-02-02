//
//  DogCollectionViewController.swift
//  myDogs
//
//  Created by Arin Halicki on 1/31/18.
//  Copyright © 2018 Arin Halicki. All rights reserved.
//

import UIKit
import CoreData

class DogCollectionViewController: UIViewController {
    
    var dogs = [DogRecord]()
    
    var itemsPerRow: CGFloat = 2.0
    var sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchAllData()
        
        if dogs.count > 0 {
            statusLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is NSIndexPath {
            let indexPath = sender as! NSIndexPath
            let destination = segue.destination as! AddDogViewController
            let senderData = dogs[indexPath.row]
            destination.delegate = self
            destination.sentData = senderData
            destination.updating = true
            destination.indexPath = indexPath
        }
        else{
            let destination = segue.destination as! AddDogViewController
            destination.delegate = self
        }

    }
    
    func fetchAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DogRecord")
        
        do {
            let result = try managedObjectContext.fetch(request)
            dogs = result as! [DogRecord]
        } catch {
            print(error)
        }
    }
}

extension DogCollectionViewController: AddDogViewControllerDelegate {
    
    func cancelButtonPressed(by controller: AddDogViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func itemSaved(by controller: AddDogViewController, with name: String, breed: String, treat: String, photo: Data, update: Bool, at: NSIndexPath?) {
        
        if update == true {
            if let ip = at {
                let item = dogs[ip.row]
                item.name = name
                item.breed = breed
                item.treat = treat
                item.photo = photo
                print("existing item updated: ", item)
            }
        }
        else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "DogRecord", into: managedObjectContext) as! DogRecord
            
            item.name = name
            item.breed = breed
            item.treat = treat
            item.photo = photo
            print("new item created: ", item)
        }
        
        do {
            try managedObjectContext.save()
        }
        catch {
            print(error)
        }
        
        fetchAllData()
        if dogs.count > 0 {
            statusLabel.isHidden = true
        }
        else {
            statusLabel.isHidden = false
        }
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteRecord(by controller: AddDogViewController, with indexPath: NSIndexPath) {
        let item = self.dogs[indexPath.row]
        
        self.managedObjectContext.delete(item)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        fetchAllData()
        if dogs.count < 1 {
            statusLabel.isHidden = false
        }
        else {
            statusLabel.isHidden = true
        }
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension DogCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! DogCell
        
        cell.dogName.text = dogs[indexPath.row].name
        
        cell.dogPhoto.image = UIImage(data:  dogs[indexPath.row].photo!)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "addDogSegue", sender: indexPath)
        
    }
    
    
}

extension DogCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}


