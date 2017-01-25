//
//  LockableTextFieldDelegate.swift
//  TextFields
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class LockableTextFieldDelegate: NSObject,UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
