//
//  ViewController.swift
//  BassPreAmp
//
//  Created by Jair-Rohm Wells on 9/27/19.
//  Copyright © 2019 Jair-Rohm Wells. All rights reserved.
//
/*
 This is sounding very good right now in headphones. It may be time to deploy to the iPad and try on the amp. I need to add the hardware input to this. Maybe i should include a switch between the audio interface and the file player so that i can have both? I'm also going to add an AKFreqTkr for a display of the audio waveform.
 
 There isn't any Audiobus code in this version. 
 */

import UIKit
import AudioKit
import AudioKitUI



class ViewController: UIViewController {
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var delayFeedbackSlider: UISlider!
    @IBOutlet weak var verbFeedbackSlider: UISlider!
    @IBOutlet weak var outputVolume: UISlider!
    @IBOutlet weak var delayMixSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var resSlider: UISlider!
    @IBOutlet weak var cfSlider: UISlider!
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var callousLable: UILabel!
    @IBOutlet weak var edgeLabel: UILabel!
    @IBOutlet weak var strideLabel: UILabel!
    @IBOutlet weak var rumpLabel: UILabel!
    
    
    var loFilter: AKMoogLadder?
    var distMixer: AKDryWetMixer?
    var callousness: AKDistortion?
    var filterBand2: AKEqualizerFilter!
    var filterBand3: AKEqualizerFilter?
    var filterBand7: AKEqualizerFilter?
    var booster: AKBooster?
    var silence: AKBooster?
    let input = AKMicrophone()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outputLabel.sizeToFit()
        callousLable.sizeToFit()
        edgeLabel.sizeToFit()
        strideLabel.sizeToFit()
        rumpLabel.sizeToFit()
        
          loFilter = AKMoogLadder(input)
            
            //    //MARK: - Eq settings
            //    /***************************************************************/
            //
            filterBand2 = AKEqualizerFilter(loFilter, centerFrequency: 35, bandwidth: 44.7, gain: 0.0)
            filterBand3 = AKEqualizerFilter(filterBand2, centerFrequency: 65, bandwidth: 70.8, gain: 0.0)
            let filterBand4 = AKEqualizerFilter(filterBand3, centerFrequency: 125, bandwidth: 141, gain: 2.0)
            let filterBand5 = AKEqualizerFilter(filterBand4, centerFrequency: 250, bandwidth: 282, gain: 0.022)
            let filterBand6 = AKEqualizerFilter(filterBand5, centerFrequency: 500, bandwidth: 562, gain: 1.5)
            filterBand7 = AKEqualizerFilter(filterBand6, centerFrequency: 10_300, bandwidth: 11_112, gain: 0.0)
            
            //    //MARK: - Dist settings
            //    /***************************************************************/
            //
            
            var callousness = AKDistortion(input, linearTerm: 1.0, squaredTerm: 1.0, cubicTerm: 1.0, softClipGain: 3.0, finalMix: 0.5)
            
            
            distMixer = AKDryWetMixer(filterBand7, callousness, balance: 0.0)
            
            //    //MARK: - Output
            //    /***************************************************************/
            //
        
            booster = AKBooster(distMixer)
        
            booster?.gain = 0.0
            
            AudioKit.output = booster
            
            try! AudioKit.start()
        }
        

    
    //    //MARK: - Slider methods
    //    /***************************************************************/
    //
   
    @IBAction func cfSliderMoved(_ sender: UISlider) {
        
        var loCutOffVal = filterBand2?.gain = Double(sender.value)
       
    }
    
    @IBAction func resSliderMoved(_ sender: UISlider) {
        
        let loResVal = filterBand3?.gain = Double(sender.value)
    }
    
    @IBAction func outputVolChanged(_ sender: UISlider) {
        let boosterVal =  booster!.gain = Double(sender.value)
    }
    
    
    @IBAction func callousSliderMoved(_ sender: UISlider) {
        let distVal = distMixer!.balance = Double(sender.value / 8)
       
    }
    
    
    
    @IBAction func edgeSliderMoved(_ sender: UISlider) {
        let edgeVal = filterBand7?.gain = Double(sender.value * 4)
       
    }
    
}
