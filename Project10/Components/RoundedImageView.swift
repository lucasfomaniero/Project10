//
//  RoundedImageView.swift
//  LojasiOS1
//
//  Created by Lucas Maniero on 17/04/19.
//  Copyright © 2019 Lucas Maniero. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = false
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.bounds.height
        self.layer.cornerRadius = height / 2
    }
    
}
