//
//  RecordSoundsViewController.swift
//  Pitch Perfect App
//
//  Created by Siva Ganesh on 24/07/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var tapToRecordLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        resumeButton.hidden = true
        pauseButton.hidden = true
    }


    @IBAction func recordAudio(sender: UIButton) {
        
        recordButton.enabled = false
        tapToRecordLabel.hidden = true
        recordingInProgress.hidden = false
        pauseButton.hidden = false
        stopButton.hidden = false
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let recordingName = "new_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Swift 2.0
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])

        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {

        if(flag){
            
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathURL: recorder.url)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            
            print("Some error in recording")
            recordButton.enabled = true
            tapToRecordLabel.hidden = false
            stopButton.hidden = true
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        
        pauseButton.hidden = true
        resumeButton.hidden = false
        audioRecorder.pause()
        
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        
        resumeButton.hidden = true
        pauseButton.hidden = false
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        
        stopButton.hidden = true
        recordingInProgress.hidden = true
        recordButton.enabled = true
        tapToRecordLabel.hidden = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
    }
}

