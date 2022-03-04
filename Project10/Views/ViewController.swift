//
//  ViewController.swift
//  Project10
//
//  Created by Lucas Maniero on 28/02/22.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "personCell"
    var people = [Person]()
    var selectedItem: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        title = "Contacts"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddPersonController))
        navigationItem.rightBarButtonItem = addButton
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        loadPeople()
    }
    
    @objc func showAddPersonController(){
        let addPersonVC = AddPersonViewController()
        addPersonVC.delegate = self
        navigationController?.pushViewController(addPersonVC, animated: true)
    }

  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? PersonCollectionViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.row]
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.personImageView.image = UIImage(contentsOfFile: path.path)
        cell.personNameLabel.text = people[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func createNewPerson(_ imageName: String) {
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let personVC = AddPersonViewController()
        personVC.person = people[indexPath.item]
        present(personVC, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame
        return .init(width: size.width - 32.0, height: size.height / 4)
//        return .init(width: 120, height: 140 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    
    func loadPeople() {
        let defaults = UserDefaults.standard

        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
}

protocol AddPersonDelegate: AnyObject {
    func shouldSaveANewPerson(_ person: Person)
}

extension ViewController: AddPersonDelegate {
    func shouldSaveANewPerson(_ person: Person) {
        people.append(person)
        save()
        collectionView.reloadData()
    }
}



