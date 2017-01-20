//
//  UIViewExtensions.swift
//  FadeExtensionDemo
//
//  Created by Gabrielle Miller-Messner on 6/26/15.
//  Copyright (c) 2015 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView (Extensions)

extension UIView {
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: ((_ finished:Bool) -> Void)?){
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: ((_ finished:Bool) -> Void)?){
        UIView.animate(withDuration: duration, delay:delay, options:UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
