//
//  ViewController.swift
//  MLSpeechSynthesizer
//
//  Created by Loganathan, Madhumitha on 4/5/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController,UIGestureRecognizerDelegate, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var speakButton: UIImageView!
    @IBOutlet var speakImage: UIImageView!
    
    var hasStarted = false
    var isSpinning = false
    
    let avSynthesizer = AVSpeechSynthesizer()
    var avUtterance = AVSpeechUtterance(string: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }

    
    func setupUI(){
        avUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        speakImage.isUserInteractionEnabled = true
        speakImage.addGestureRecognizer(tapGestureRecognizer)
        speakImage.image = UIImage(named:"microphone")
        textView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,  action: #selector(self.handleLongPress(sender:)))
        speakImage.addGestureRecognizer(longPressRecognizer)
    }
    
    
    
    
    // UITapGestureRecognizer methods

    func handleTap(sender: UITapGestureRecognizer) {
        if(!hasStarted){
            startSpeaking()
        }
        else {
            if (isSpinning){
                pauseSpeaking()
            }else{
               resumeSpeaking()
            }
        }
    }
    
    
    func handleLongPress(sender: UITapGestureRecognizer) {
        stopSpeaking()
    }
    
    // MARK : Text to speech methods
    
    func startSpeaking(){
        speakImage.startSpinning()
        hasStarted = true
        isSpinning = true
        avUtterance = AVSpeechUtterance(string: textView.text)
        avUtterance.rate = 0.4
        avSynthesizer.speak(avUtterance)

    }
    
    func stopSpeaking(){
        hasStarted = false
        speakImage.stopSpinning()
        textView.text = ""
        avSynthesizer.pauseSpeaking(at: .immediate)
    }
    
    func pauseSpeaking(){
        speakImage.pauseSpinning()
        isSpinning = false
        avSynthesizer.pauseSpeaking(at: .word)
    }
    
    func resumeSpeaking(){
        speakImage.resumeSpinning()
        avSynthesizer.continueSpeaking()
        isSpinning = true
    }
    
    // MARK: UITextView Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Referred : https://github.com/benbahrenburg/SpinningImageView-Example/
// Added pause and resume

extension UIView {
    
    //Start Spinning view
    func startSpinning(duration: Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    //Stop Spinning view
    func stopSpinning() {
        
        let kAnimationKey = "rotation"
        let pausedTime = self.layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 1.0
        layer.beginTime = 0.0
        let timeSincePause =  layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    //Pause Spinning view
    func pauseSpinning() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }
    
    //Resume Spinning view
    func resumeSpinning() {
        let pausedTime = self.layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause =  layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    
    
}
