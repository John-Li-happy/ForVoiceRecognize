//
//  ViewController.swift
//  ForVoiceRecognize
//
//  Created by Zhaoyang Li on 2/7/21.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    
    let audioEngin = AVAudioEngine()
    let speechRecogizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recogitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        speekOutLoud()
        
//        recordAndRecognizeSpeech()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        resultLabel.text = ""
        if audioEngin.isRunning {
            startButton.setTitle("Start", for: .normal)
            audioEngin.inputNode.removeTap(onBus: 0)
            recogitionTask?.cancel()
            audioEngin.stop()
        } else {
            recordAndRecognizeSpeech()
            startButton.setTitle("Stop", for: .normal)
        }
    }
    
    func speekOutLoud() {
        let utterance = AVSpeechUtterance(string: "do you like me?")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngin.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngin.prepare()
        do {
            try audioEngin.start()
        } catch { print(error) }
        
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable { return }
        
        recogitionTask = speechRecogizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.resultLabel.text = bestString
            } else if let error = error {
                print(error)
            }
        })
    }
}

