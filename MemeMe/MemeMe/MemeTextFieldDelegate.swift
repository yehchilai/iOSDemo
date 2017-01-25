//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = textField.text! as String
        let attr = NSAttributedString(string: newText, attributes: [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : NSNumber(value: -4.0),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
            ])
        
        textField.attributedText = attr
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
