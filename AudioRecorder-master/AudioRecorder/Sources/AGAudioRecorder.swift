//
//  AGAudioRecorder.swift
//  AudioRecorder
//
//  Created Ashvin Gudaliya on 04/12/19.
//  Copyright © 2019 AshvinGudaliya. All rights reserved.
//

import UIKit
import AVFoundation

enum AGRecorderState {
    case prepareToRecord
    case recording
    case pause
    case stop
    case finish
    case failed(Error)
}

class AGAudioRecorder: NSObject {
    private var fileManager: AGFileManager?
    
    private var recorder: AVAudioRecorder? = nil
    private var meterTimer: Timer! = nil
    private var currentTimeInterval: TimeInterval = 0.0
    
    var recorderStateChangeHandler: ((AGRecorderState) -> Void)?
    var timeIntervalHandler: ((TimeInterval) -> Void)?
    
    var isRecording: Bool {
        return self.recorder?.isRecording ?? false
    }
    
    init(withFileManager fileManager: AGFileManager) {
        super.init()
        self.fileManager = fileManager
    }
    
    func setupRecorder() {
        
        guard let fileManager = self.fileManager else {
            return 
        }
        
        do {
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM), //wav 파일로 저장
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 4,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            recorder = try AVAudioRecorder(url: fileManager.fileUrl(), settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorderStateChangeHandler?(.prepareToRecord)
        }
        catch let error {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    @objc private func updateAudioMeter(timer: Timer) {
        guard let recorder = recorder else { return }
        
        if recorder.isRecording {
            
            
            currentTimeInterval = currentTimeInterval + 0.01
            let min = Int(currentTimeInterval / 60)
            let hr = Int(min / 60)
            let sec = Int(currentTimeInterval.truncatingRemainder(dividingBy: 60))
            print(String(format: "%02d:%02d:%02d\n", hr, min, sec))

            print("0 channel: ")
            print(recorder.peakPower(forChannel: 0))
            print("1 channel: ")
            print(recorder.peakPower(forChannel: 1))
            print("2 channel: ")
            print(recorder.peakPower(forChannel: 2))
            print("3 channel: ")
            print(recorder.peakPower(forChannel: 3))
            
//            let msg = String(recorder.peakPower(forChannel: 3))
//
//            label.text = msg
            if let channelAssignments = recorder.channelAssignments {
                for channelDescription in channelAssignments {
                    // channelDescription에 대한 작업 수행
                    // 예를 들어, channelDescription의 속성에 접근하거나 값을 변경할 수 있습니다.
                    // channelDescription의 프로퍼티에는 channelName, owningPortUID, channelNumber 등이 있을 수 있습니다.
                    let channelName = channelDescription.channelName
                   // let owningPortUID = channelDescription.owningPortUID
                    let channelNumber = channelDescription.channelNumber
                    let chanelLabel = channelDescription.channelLabel
                    print(channelName)
                    print(channelNumber)
                    print(chanelLabel)
                    // 이제 channelDescription 객체의 속성에 접근하여 원하는 작업을 수행할 수 있습니다.
                }
            }
            else{
                print("no assignment")
            }

            recorder.updateMeters()
            timeIntervalHandler?(recorder.currentTime)
        } else {
            meterTimer.invalidate()
        }
    }
    
    func doRecord() {
        
        guard let recorder = recorder else {
            return }
        if recorder.isRecording {
            doStop()
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            recorder.record()
            currentTimeInterval = 0.0
            meterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
            recorderStateChangeHandler?(.recording)
        } catch {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    func doStop() {
        
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }

        do {
            recorder.stop()
            try AVAudioSession.sharedInstance().setActive(false)
            meterTimer?.invalidate()
            recorderStateChangeHandler?(.finish)
        } catch {
            recorderStateChangeHandler?(.failed(error))
        }
    }
    
    func doPause() {
        guard let recorder = recorder else { return }
        guard recorder.isRecording else { return }

        recorder.pause()
        meterTimer?.invalidate()
        recorderStateChangeHandler?(.pause)
    }
    
    func doResume() {
        guard recorder != nil else { return }
        if (recorder?.isRecording ?? true) {
            self.doStop()
        }

        recorder?.record()
        meterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
        recorderStateChangeHandler?(.recording)
    }
}

extension AGAudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recorderStateChangeHandler?(.finish)
        } else {
            doStop()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let e = error {
            recorderStateChangeHandler?(.failed(e))
        } else {
            doStop()
        }
    }
}
