//
//  UINavigationController+Ext.swift
//  FoodPie
//
//  Created by ciggo on 4/7/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit

extension UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
