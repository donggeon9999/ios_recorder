//
//  ViewController.swift
//  AudioRecorder
//
//  Created Ashvin Gudaliya on 04/12/19.
//  Copyright © 2019 AshvinGudaliya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    lazy var textview: UITextView = {
//        let textView: UITextView = UITextView(frame: CGRect(x:10, y:100, width:400, height:200))
//
//               // Set the background of TextView to Orange.
//                textView.backgroundColor = .lightGray
//
//               // Set the text to be displayed.
////               textView.text = "asdlfkjslkdfion1230914098snflsdfn98123n 1234567890 fbaiwerp[q;afnm,vjjsdfa \na\nb\nc\ndefghijklmnopqrstuwxyz \n https://medium.com/@calmone"
//               // Round the corners.
//               textView.layer.masksToBounds = true
//
//               // Set the size of the roundness.
//               textView.layer.cornerRadius = 20.0
//
//               // Set the thickness of the border.
//               textView.layer.borderWidth = 1
//
//               // Set the border color to black.
//               textView.layer.borderColor = UIColor.black.cgColor
//
//               // Set the font.
//               textView.font = UIFont.systemFont(ofSize: 20.0)
//
//               // Set font color.
//               textView.textColor = UIColor.black
//
//               // Set left justified.
//               textView.textAlignment = NSTextAlignment.left
//
//               // Automatically detect links, dates, etc. and convert them to links.
//               textView.dataDetectorTypes = UIDataDetectorTypes.all
//
//               // Set shadow darkness.
//               textView.layer.shadowOpacity = 0.5
//
//               // Make text uneditable.
//               textView.isEditable = false
//
//               return textView
//           }()
//
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var barProgress1: UIProgressView!
    @IBOutlet weak var barProgress2: UIProgressView!
    @IBOutlet weak var barProgress3: UIProgressView!
    @IBOutlet weak var barProgress4: UIProgressView!
    
    let audioManager: AGManager = AGManager(withFileManager: AGFileManager(withFileName: nil))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioManager.delegate = self
        audioManager.checkRecordPermission()
//        self.view.addSubview(self.textview)
       
    }

    @IBAction func redordingAction(_ sender: UIButton) {
        if !self.audioManager.isRecording {
            self.audioManager.recordStart()
        
        } else {
            self.audioManager.stopRecording()
            
            //공유하기 기능 추가 -> 데이터 확인용
            var objectsToShare = [Any]()
                objectsToShare.append(audioManager.file_path)
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y:self.view.bounds.midY, width:0, height:0)
                    // 공유하기 기능 중 제외할 기능이 있을 때 사용
            //        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func playingAction(_ sender: UIButton) {
        if !self.audioManager.isPlaying {
            self.audioManager.startPalyer()
        } else {
            self.audioManager.stopPlaying()
        }
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        audioManager.newRecoding(fileManager: AGFileManager(withFileName: nil))
        btnRecord.isEnabled = true
        btnPlayer.isEnabled = false
    }
}

extension ViewController: AGManagerDelegate {
    func recorderAndPlayer(_ manager: AGManager, withStates state: AGManagerState) {
        switch state {
        case .undetermined:
            break
            
        case .granted:
            btnRecord.setTitle("Initialize Recorder", for: .normal)
            btnPlayer.setTitle("Initialize Player", for: .normal)
            btnRecord.isEnabled = true
            btnPlayer.isEnabled = false
            
        case .denied:
            break
            
        case .error(let erro):
            print(erro.localizedDescription)
        }
    }
    
    func recorderAndPlayer(_ recoder: AGAudioRecorder, withStates state: AGRecorderState) {
        switch state {
        case .prepareToRecord:
            btnRecord.setTitle("Ready to record", for: .normal)
            btnPlayer.setTitle("Ready to Play", for: .normal)
            btnRecord.isEnabled = true
            btnPlayer.isEnabled = false
            
        case .recording:
            btnRecord.setTitle("Recording....", for: .normal)
            btnPlayer.isEnabled = false
//            textview.text = "AGAudioRecorder" + DateFormatter().string(from:Date())
            
        case .pause:
            btnRecord.setTitle("Pause recording", for: .normal)
            
        case .stop:
            btnRecord.setTitle("Stop recording", for: .normal)
            
        case .finish:
            btnRecord.setTitle("Recording Finish", for: .normal)
            
        case .failed(let error):
            btnRecord.setTitle(error.localizedDescription, for: .normal)
            btnPlayer.isEnabled = false
            btnRecord.isEnabled = false
        }
    }
    
    func recorderAndPlayer(_ player: AGAudioPlayer, withStates state: AGPlayerState) {
        switch state {
        case .prepareToPlay:
            btnPlayer.setTitle("Ready to Play", for: .normal)
            btnRecord.isEnabled = false
            btnPlayer.isEnabled = true
            
        case .play:
            btnPlayer.setTitle("Playing", for: .normal)
            
        case .pause:
            btnPlayer.setTitle("Pause Playing", for: .normal)
            
        case .stop:
            btnPlayer.setTitle("Stop Playing", for: .normal)
            
        case .finish:
            btnPlayer.setTitle("Play again", for: .normal)
            
        case .failed(let error):
            btnRecord.setTitle(error.localizedDescription, for: .normal)
            btnPlayer.isEnabled = false
            btnRecord.isEnabled = false
        }
    }
    
    func audioRecorderTime(currentTime timeInterval: TimeInterval, formattedString: String) {
        
    }
}
