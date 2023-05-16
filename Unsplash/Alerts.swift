//
//  Alerts.swift
//  Unsplash
//
//  Created by tikh on 13.05.2023.
//

import UIKit

struct Alerts {
    
    static let defaultAlert: UIAlertController = {
        let alert = UIAlertController(title: "Something went wrong", message: "Please, try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }()
}
