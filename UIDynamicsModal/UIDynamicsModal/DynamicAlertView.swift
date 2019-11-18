//
//  DynamicAlertView.swift
//  UIDynamicsModal
//
//  Created by Fábio Salata on 13/11/19.
//  Copyright © 2019 Fábio Salata. All rights reserved.
//

import UIKit

class DynamicAlertView: UIView {
    enum ModalBehavior {
        case snap
        case attachment
    }
    
    var backgroundView: UIView!
    var dialogView: UIView!
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!
    var attachment: UIAttachmentBehavior!
    
    var shouldClose = false
    var selectedBehavior: ModalBehavior!
    
    convenience init(title: String, message: String) {
        self.init(frame: UIScreen.main.bounds)
        
        setupView(title, message)
        
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    func setupView(_ title: String, _ message: String) {
        backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.1
        addSubview(backgroundView)
        
        dialogView = UIView()
        dialogView.frame.size = CGSize(width: 300, height: 200)
        dialogView.center = CGPoint(x: self.center.x, y: self.frame.origin.y - self.dialogView.frame.height)
        dialogView.backgroundColor = UIColor(red: 36/255, green: 165/255, blue: 211/255, alpha: 1)
        dialogView.layer.cornerRadius = 5
        dialogView.clipsToBounds = true
        addSubview(dialogView)
        
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        dialogView.addGestureRecognizer(panGesture)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func show(behavior: ModalBehavior) {
        backgroundView.alpha = 0
        UIApplication.shared.delegate?.window!?.rootViewController?.view.addSubview(self)
        
        selectedBehavior = behavior
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.1
        }
        
        switch behavior {
        case .snap:
            snap = UISnapBehavior(item: dialogView, snapTo: center)
            animator.addBehavior(snap)
            
        case .attachment:
            dialogView.center = CGPoint(x: -1000, y: self.center.y)
            
            let gravity = UIGravityBehavior(items: [dialogView])
    
            animator.addBehavior(gravity)
            
            let anchorPoint = CGPoint(x: self.center.x, y: self.center.y - 200)
            
            attachment = UIAttachmentBehavior(item: dialogView, attachedToAnchor: anchorPoint)
            attachment.length = 200
            attachment.damping = 0.1
            
            let dynamic = UIDynamicItemBehavior()
            dynamic.addItem(dialogView)
            dynamic.resistance = 1.5
            
            animator.addBehavior(dynamic)
            animator.addBehavior(attachment)
        }
    }
    
    func dismiss(behavior: ModalBehavior) {
        switch behavior {
        case .attachment:
            animator.removeAllBehaviors()
            let gravity = UIGravityBehavior(items: [dialogView])
            gravity.gravityDirection = CGVector(dx: 0.0, dy: 10.0)
            animator.addBehavior(gravity)
            
            let itemBehavior = UIDynamicItemBehavior(items: [dialogView])
            itemBehavior.addAngularVelocity(CGFloat(-Double.pi / 2), for: dialogView)
            animator.addBehavior(itemBehavior)
            
        case .snap:
            if snap != nil {
                animator.removeBehavior(snap)
            }
            
            snap = UISnapBehavior(item: dialogView, snapTo: CGPoint(x: self.center.x, y: self.frame.size.height + dialogView.frame.height))
            animator.addBehavior(snap)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func tapHandler(_ recognizer: UITapGestureRecognizer) {
        dismiss(behavior: selectedBehavior)
    }
    
    @objc func panHandler(_ gesture: UIPanGestureRecognizer) {
        let panLocationInView = gesture.location(in: self.backgroundView)
        let panLocationInDialogView = gesture.location(in: self.dialogView)
        
        switch gesture.state {
        case .began:
            animator.removeAllBehaviors()
            
            let offset = UIOffset(horizontal: panLocationInDialogView.x - dialogView.bounds.midX, vertical: panLocationInDialogView.y - dialogView.bounds.midY)
            attachment = UIAttachmentBehavior(item: dialogView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            
            animator.addBehavior(attachment)
            
        case .changed:
            attachment.anchorPoint = panLocationInView
            
        case .ended:
            animator.removeAllBehaviors()
            
            snap = UISnapBehavior(item: dialogView, snapTo: self.backgroundView.center)
            animator.addBehavior(snap)
            
            if gesture.translation(in: self.backgroundView).y > 200 {
                dismiss(behavior: .attachment)
            }
            
        default:
            break
        }
    }
}
