//
//  AuthCompleteTransition.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation
import UIKit

class AuthCompleteTransition : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.72
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? BaseViewController
        
        let finalCenter = CGPointMake(160.0, (fromVC!.view.bounds.size.height / 2) - 1000.0)
        
        let options = UIViewAnimationOptions.CurveEaseIn
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 0.64,
            initialSpringVelocity: 0.22,
            options: options,
            animations: {
                fromVC!.view.center = finalCenter
                fromVC!.transitioningBackgroundView.alpha = 0.0
            },
            completion: { finished in
                fromVC!.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }
    
}