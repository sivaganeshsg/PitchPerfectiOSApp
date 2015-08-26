//
//  PlaySoundsViewController.swift
//  Pitch Perfect App
//
//  Created by Siva Ganesh on 24/07/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer2.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSnail(sender: UIButton) {
        
        playAwesomeSound(0.5)
        
    }

    @IBAction func playRabbit(sender: UIButton) {
        
        playAwesomeSound(2.0)
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }

    @IBAction func playDarthvader(sender: UIButton) {

        playAudioWithVariablePitch(-1000)
        
    }
    
    @IBAction func playParrot(sender: UIButton) {
        
        playAwesomeSound(1)
        
        
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
        
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        
        stopAllSound()
        
    }
    
    func playAwesomeSound(audioRate: Float) -> Void {
        
        stopAllSound()
        
        audioPlayer.currentTime = 0
        audioPlayer.rate = audioRate
        audioPlayer.play()
    
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAllSound()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAllSound() -> Void {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Disable Echo Player where we use audioPlayer2
        audioPlayer2.stop()
        
    }
    
}
