//
//  RoundedTextField.swift
//  FoodPie
//
//  Created by 黄小净 on 2020/4/13.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    let edgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInsets)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
