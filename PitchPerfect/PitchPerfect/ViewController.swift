//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Yeh-chi Lai on 1/21/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(_ sender: Any) {
        print("Record button is pressed.")
        recordingLabel.text = "Recording in progress..."
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        print("Stop recording button is pressed.")
    }
}

