//
//  +UIView.swift
//  Project10
//
//  Created by Lucas Maniero on 28/02/22.
//

import UIKit

extension UIView {
    
    func fillSuperView() {
        guard let superview = superview else {return}
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
