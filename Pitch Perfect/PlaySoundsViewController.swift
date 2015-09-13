//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thyago Silva on 04/09/15.
//  Copyright (c) 2015 Avalanche. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var soundPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        soundPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSnailSound(sender: UIButton) {
        playSound(0.5)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playSound(2.0)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        soundPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    
    func playSound(rate: Float) {
        soundPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        soundPlayer.rate = rate
        soundPlayer.currentTime = 0.0
        soundPlayer.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        soundPlayer.stop()
    }

}
