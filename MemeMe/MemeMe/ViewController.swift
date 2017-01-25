//
//  ViewController.swift
//  MemeMe
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    let memetextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.delegate = memetextFieldDelegate
        bottomTextField.delegate = memetextFieldDelegate
        subscribeKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubsribeKeyboardNotification()
    }
    
    // MARK: Implement IBAction
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
    }
    // MARK: Implement UIImagePickerControllerDelegate Protocols
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        print("UIImagePickerControllerOriginalImage")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //            print("UIImagePickerControllerOriginalImage - success")
            imageVIew.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Implement keyboard reaction
    // show keyboard
    func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeKeyboardNotification(){
        // show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        // hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unsubsribeKeyboardNotification(){
        // show keyboard
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        // hide keyboard
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    // hide keyboard
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    // MARK: Sgenerate and save a meme image
    func save() {
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalImage: imageVIew.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.tabBarController?.tabBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.tabBarController?.tabBar.isHidden = false
        return memedImage
    }
}

