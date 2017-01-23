//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Yeh-chi Lai on 1/22/17.
//  Copyright © 2017 iamhomebody. All rights reserved.
//

import UIKit

class PlaySoundsViewController: UIViewController {

    var recordedAudioURL: URL!
    
    @IBOutlet weak var slowButton:UIButton!
    @IBOutlet weak var fastButton:UIButton!
    @IBOutlet weak var highPitchButton:UIButton!
    @IBOutlet weak var lowPitchButton:UIButton!
    @IBOutlet weak var echoButton:UIButton!
    @IBOutlet weak var reverbButton:UIButton!
    @IBOutlet weak var stopButton:UIButton!
    
    @IBAction func playSoundForButton(_ sender:UIButton){
        print("Play sound Button.")
    }
    
    @IBAction func stopButtonPressed(_ sender:UIButton){
        print("Stop playinng Button.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
