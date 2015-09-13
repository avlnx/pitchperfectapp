//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thyago Silva on 04/09/15.
//  Copyright (c) 2015 Avalanche. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var session:AVAudioSession!
    
    func resetView()
    {
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeRecordingButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to Record"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resetView()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        recordingInProgress.text = "Recording..."
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeRecordingButton.hidden = false
        resumeRecordingButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "myaudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //println(filePath)
        
        session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        resumeRecordingButton.enabled = true
        pauseButton.enabled = false
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeRecordingButton.enabled = false
        pauseButton.enabled = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag)
        {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url)
            
            // reset session's category to playback so the sound plays loud enough
            session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
            // segue
            //self.performSegueWithIdentifier("stopRecording", sender: nil)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful!")
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Recording not successful! Try again.", preferredStyle: .Alert)
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
            resetView()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording")
        {
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)    }
    }

