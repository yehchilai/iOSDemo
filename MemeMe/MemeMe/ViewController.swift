//
//  ViewController.swift
//  MemeMe
//
//  Created by Yeh-chi Lai on 1/24/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageVIew: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pickAnImage(_ sender: Any) {
        
        let controller = UIImagePickerController()
        
        present(controller, animated: true, completion: nil)
    }

}

