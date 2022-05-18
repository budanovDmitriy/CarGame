//
//  SettingsViewController.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 31.03.2022.
//

import UIKit
import FirebaseAnalytics

class SettingsViewController: UIViewController {
    
    // MARK: - Publick properties
    var speedIsChanged = false
    var nameIsChanged = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pictureImage: UIImageView!
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
        readPicture()
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
    
    private func readPicture(){
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent("photo.png")
        let newImage = UIImage(contentsOfFile: imageURL.path) ?? nil
        if newImage != nil {
            pictureImage.image = newImage
        } else {
            pictureImage.image = UIImage(named: "GameLogo")
        }
    }
    
    private func writePicture(image:UIImage) {
        let imageData = image.pngData()!
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent("photo.png")
        try! imageData.write(to: imageURL)
        let newImage = UIImage(contentsOfFile: imageURL.path)!
        pictureImage.image = newImage
    }
    
    // MARK: - IBActions
    
    @IBAction func colorChanged(_ sender: UISegmentedControl) {
        Analytics.logEvent("ChangeColor"
        ])
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
    
    @IBAction func changePicture(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Galery", style: .default){_ in
            self.openGallery()
        })
        alert.addAction(UIAlertAction(title: "Camera", style: .default){_ in
            self.openCamera()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    @IBAction func barrierChanged(_ sender: UISegmentedControl) {
        Analytics.logEvent("ChangeBarrier", parameters: [
            "OldBarrier": AppSettings.shared.items as NSObject
        ])
        switch barrierSegment.selectedSegmentIndex {
        case 0:AppSettings.shared.items = "tree"
        case 1:AppSettings.shared.items = "stone"
        case 2:AppSettings.shared.items = "rubish"
        default:break
        }
        Analytics.logEvent("ChangeBarrier", parameters: [
            "NewBarrier": AppSettings.shared.items as NSObject
        ])
    }
    
    @IBAction func steppingOfSpeed(_ sender: UIStepper) {
        if !speedIsChanged {
            sender.value =  Double(AppSettings.shared.speed)
            speedIsChanged = true
        }
        speedLabel.text = "Your speed : \(sender.value)"
        Analytics.logEvent("ChangeSpeed", parameters: [
            "OldSpeed": AppSettings.shared.speed as NSObject,
            "NewSpeed": sender.value as NSObject
        ])
        AppSettings.shared.speed = Int(sender.value)
    }
    
    // MARK: - objc methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        Analytics.logEvent("ChangeName", parameters: [
            "OldName": AppSettings.shared.name as NSObject
        ])
        AppSettings.shared.name = textField.text ?? ""
        Analytics.logEvent("ChangeName", parameters: [
            "NewName": AppSettings.shared.name as NSObject
        ])
    }
}

private extension SettingsViewController {
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SettingsViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            writePicture(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
