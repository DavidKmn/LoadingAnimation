//
//  ViewController.swift
//  LoadingAnimation
//
//  Created by David on 07/08/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingActivityIndicator.spinnerColor(UIColor.darkGray)
        LoadingActivityIndicator.show()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSpinner)))
     }
    
    @objc private func dismissSpinner() {
        LoadingActivityIndicator.dismiss()
    }

}

