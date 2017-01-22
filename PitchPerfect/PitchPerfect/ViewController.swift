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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in progress..."
        recordButton.isEnabled = false;
        stopRecordingButton.isEnabled = true;
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        recordButton.isEnabled = true;
        stopRecordingButton.isEnabled = false;
        recordingLabel.text = "Tap to Record"
        
    }
}

