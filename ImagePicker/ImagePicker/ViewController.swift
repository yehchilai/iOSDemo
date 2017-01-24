//
//  ViewController.swift
//  ImagePicker
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func experiment(_ sender: UIButton) {
        let nextController = UIImagePickerController()
        self.present(nextController, animated: true, completion: nil)
    }

    @IBAction func experimentAlert(_ sender: Any) {
        let controller = UIAlertController()
        controller.title = "Test Alert"
        controller.message = "This is a test"
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func experimentActivity(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
}

