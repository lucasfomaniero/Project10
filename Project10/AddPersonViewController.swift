//
//  AddPersonViewController.swift
//  Project10
//
//  Created by Lucas Maniero on 01/03/22.
//

import UIKit

class AddPersonViewController: UIViewController {
    var person: Person? {
        didSet {
            guard let person = person else {return}
            let path = getDocumentsDirectory().appendingPathComponent(person.image)
            self.personImageView.image = UIImage(contentsOfFile: path.path)
            self.textField.text = person.name
        }
    }
    weak var delegate: AddPersonDelegate?
    lazy var saveButton: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNewPerson))
        return saveButton
    }()
    
    let personImageView: RoundedImageView = {
        let iv = RoundedImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "lucas")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.shouldRasterize = true
        return iv
    }()
    
    lazy var choosePhotoButton: UIButton = {
        let photoButton = UIButton(frame: .zero)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.backgroundColor = .clear
        photoButton.addTarget(self, action: #selector(showImagePickerController), for: .touchUpInside)
        return photoButton
    }()
    
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemBackground
        tf.font = .systemFont(ofSize: 18, weight: .semibold)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Full name"
        tf.textAlignment = .center
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = saveButton
        layoutConstraints()
    }
    
    fileprivate func layoutConstraints() {
        view.addSubview(personImageView)
        view.addSubview(choosePhotoButton)
        
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            personImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor),
            personImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 32),
            textField.widthAnchor.constraint(equalTo: personImageView.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 32),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            choosePhotoButton.leadingAnchor.constraint(equalTo: personImageView.leadingAnchor),
            choosePhotoButton.topAnchor.constraint(equalTo: personImageView.topAnchor),
            choosePhotoButton.trailingAnchor.constraint(equalTo: personImageView.trailingAnchor),
            choosePhotoButton.bottomAnchor.constraint(equalTo: personImageView.bottomAnchor)
        ])
    }
    
    
    @objc func showImagePickerController() {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func saveNewPerson() {
        guard let name = textField.text, let imageString = saveImage(personImageView.image) else {return}
        if name.isEmpty {return}
        let person = Person(name: name, image: imageString)
        textField.resignFirstResponder()
        delegate?.shouldSaveANewPerson(person)
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddPersonViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage, let imageName = saveImage(image) else { return }
        print(imageName)
        let person = Person(name: textField.text ?? "Unknown", image: imageName)
        self.person = person
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(_ image: UIImage?)-> String? {
        guard let image = image else {
            return nil
        }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        return imageName
    }
    
}
 
extension AddPersonViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return false}
        return text.count > 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}
