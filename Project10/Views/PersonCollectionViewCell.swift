//
//  PersonCollectionViewCell.swift
//  Project10
//
//  Created by Lucas Maniero on 28/02/22.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    let shadowView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.shadowRadius = 4
        sv.layer.shadowColor = UIColor.gray.cgColor
        sv.layer.shadowOffset = .init(width: 2, height: 2)
        sv.layer.shadowOpacity = 0.6
        return sv
    }()
    
    let cellContentView: UIView = {
        let cv = UIView()
        cv.layer.borderWidth = 1
        cv.backgroundColor = UIColor.systemBackground
        cv.layer.borderColor = UIColor.lightGray.cgColor
        cv.layer.cornerRadius = 5
        
        return cv
    }()
    
    let personImageView: RoundedImageView = {
        let iv = RoundedImageView(frame: .zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "custom.camera.circle")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.shouldRasterize = true
        return iv
    }()
    
    let personNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.text = "Person"
        return nameLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        self.addSubview(shadowView)
        shadowView.addSubview(cellContentView)
        shadowView.fillSuperView()
        cellContentView.addSubview(personImageView)
        cellContentView.addSubview(personNameLabel)
        cellContentView.fillSuperView()
        
        //personImageView anchors
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: 16),
            personImageView.centerXAnchor.constraint(equalTo: cellContentView.centerXAnchor),
            personImageView.heightAnchor.constraint(equalTo: cellContentView.heightAnchor, multiplier: 0.6),
            personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            personNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            personNameLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8),
            personNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            personNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
            personNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
    }
}
