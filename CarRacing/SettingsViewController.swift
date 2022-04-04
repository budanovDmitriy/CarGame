//
//  SettingsViewController.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 31.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Publick properties
    
    var speedIsChanged = false
    var nameIsChanged = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var colorSegment: UISegmentedControl!
    @IBOutlet weak var barrierSegment: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var speedLabel: UILabel!
    
    // MARK: - Override methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        speedLabel.text = "Your speed : \(AppSettings.shared.speed)"
        textField.text = AppSettings.shared.name
        textField.addTarget(self, action: #selector(SettingsViewController.textFieldDidChange(_:)), for: .editingChanged)
        segmentColor()
        segmentBarrier()
    }
   
    // MARK: - Private methods
    
     private func segmentColor() {
        switch AppSettings.shared.carColor {
        case .blue: colorSegment.selectedSegmentIndex = 2
        case .red: colorSegment.selectedSegmentIndex = 1
        case .green: colorSegment.selectedSegmentIndex = 0
        default : break
        }
    }
    
    private func segmentBarrier() {
       switch AppSettings.shared.items {
       case "stone": barrierSegment.selectedSegmentIndex = 1
       case "tree": barrierSegment.selectedSegmentIndex = 0
       case "rubish": barrierSegment.selectedSegmentIndex = 2
       default : break
       }
   }
    
    // MARK: - IBActions
    
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        switch colorSegment.selectedSegmentIndex
        {
        case 0: do {
            AppSettings.shared.carColor = .green
        }
        case 1: do {
            AppSettings.shared.carColor = .red
        }
        case 2: do {
            AppSettings.shared.carColor = .blue
        }
        default : break
        }
    }
    
    @IBAction func barrierChanged(_ sender: UISegmentedControl) {
        switch barrierSegment.selectedSegmentIndex{
        case 0:AppSettings.shared.items = "tree"
        case 1:AppSettings.shared.items = "stone"
        case 2:AppSettings.shared.items = "rubish"
        default:break
        }
    }
    
    @IBAction func steppingOfSpeed(_ sender: UIStepper) {
        if !speedIsChanged {
            sender.value =  Double(AppSettings.shared.speed)
            speedIsChanged = true
        }
        speedLabel.text = "Your speed : \(sender.value)"
        AppSettings.shared.speed = Int(sender.value)
    }
    
    // MARK: - objc methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        AppSettings.shared.name = textField.text ?? ""
    }
    
    
}
