//
//  CashTextFieldDelegate.swift
//  TextFields
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class CashTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
//        print(oldText)
        let newText = oldText.replacingCharacters(in: range, with: string)
//        print(newText)
        var newTextString = String(newText)
        let digits = CharacterSet.decimalDigits
        var digitString = ""
        for c in (newTextString?.unicodeScalars)!{
            if digits.contains(UnicodeScalar(c.value)!){
                digitString.append("\(c)")
            }
        }
        var dollar:String = "";
        var cent:String = "";
//        print("digitString: \(digitString)")
        if let digitInt = Int(digitString){
//            print("digitInt: \(digitInt)")
            let beforeDot = digitInt/100
            dollar = String(beforeDot)
            let afterDot = digitInt%100
            if afterDot < 10{
                cent = "0\(String(afterDot))"
            }else
            {
                cent = String(afterDot)
            }
            
        }else{
            print("Cannot generate digit value")
            dollar = "0"
            cent = "00"
        }
//        print("beforeDot: \(dollar), afterDot: \(cent)")
        textField.text = "$\(dollar).\(cent)"
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "$0.00"
        }
    }

}
