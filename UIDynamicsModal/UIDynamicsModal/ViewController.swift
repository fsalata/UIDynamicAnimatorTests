//
//  ViewController.swift
//  UIDynamicsModal
//
//  Created by Fábio Salata on 13/11/19.
//  Copyright © 2019 Fábio Salata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showSnapModalHandler(_ sender: Any) {
        let dynamicModal = DynamicAlertView(title: "Test", message: "Testing UIDynamicAnimator modal")
        dynamicModal.show(behavior: .snap)
    }
    
    @IBAction func showAttachmentModalHandler(_ sender: Any) {
        let dynamicModal = DynamicAlertView(title: "Test", message: "Testing UIDynamicAnimator modal")
        dynamicModal.show(behavior: .attachment)
    }
}

