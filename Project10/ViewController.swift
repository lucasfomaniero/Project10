//
//  ViewController.swift
//  Project10
//
//  Created by Lucas Maniero on 28/02/22.
//

import UIKit

class ViewController: UICollectionViewController {
    let cellID = "personCell"
    var people = [Person]()
    var selectedItem: IndexPath?
    
    lazy var renameAlert: UIAlertController = {
        let alert = UIAlertController(title: "Rename person", message: "Type the new name:", preferredStyle: .alert)
        alert.addTextField()
        let okAction = UIAlertAction(title: "OK", style: .default, handler: renamePerson)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        print("✅ Created the renameAlert")
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        title = "Contacts"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = addButton
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)

    }
    
    func renamePerson(_ action: UIAlertAction?) {
        guard let name = renameAlert.textFields?[0].text, let index = selectedItem else {return}
        people[index.item].name = name
        renameAlert.textFields?[0].text = ""
        collectionView.reloadData()
    }
    
    @objc func addNewPerson() {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
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
    

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath
        present(renameAlert, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        createNewPerson(imageName)

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

