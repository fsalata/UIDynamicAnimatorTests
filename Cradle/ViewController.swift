//
//  ViewController.swift
//  Cradle
//
//  Created by Fábio Salata on 13/11/19.
//  Copyright © 2019 Fábio Salata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var square1: UIView!
    @IBOutlet weak var square2: UIView!
    @IBOutlet weak var square3: UIView!
    
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let squares: [UIDynamicItem] = [square1, square2, square3]
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let gravity = UIGravityBehavior(items: squares)

        animator.addBehavior(gravity)

        var nextAnchorX = 250
        
        for square in squares {
            let anchorPoint = CGPoint(x: nextAnchorX, y: 0)
            nextAnchorX -= 30
            let attachment = UIAttachmentBehavior(item: square, attachedToAnchor: anchorPoint)
            attachment.damping = 0.1
            animator.addBehavior(attachment)

            let dynamicBehavior = UIDynamicItemBehavior()
            dynamicBehavior.addItem(square)
            dynamicBehavior.density = CGFloat(arc4random_uniform(3) + 1)
            dynamicBehavior.elasticity = 0.8
            animator.addBehavior(dynamicBehavior)
        }

        let collisions = UICollisionBehavior(items: squares)

        animator.addBehavior(collisions)
        
    }
    
    @objc func tapHandler(_ recognizer: UITapGestureRecognizer) {
        let tapPoint = recognizer.location(in: view)
        
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        snap = UISnapBehavior(item: square1, snapTo: tapPoint)
        animator.addBehavior(snap)
    }


}

