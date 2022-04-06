//
//  ViewController.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 29.03.2022.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK: - IBOutlets

    
    @IBOutlet weak var photoPicture: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
   
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(dismissBlur)
        )
        blurView.addGestureRecognizer(tapRecognizer)
        menuWidth.constant = 0
        blurView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nickLabel.text = AppSettings.shared.name
        readPicture()
    }
    
    // MARK: - Private methods
    
    private func readPicture(){
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent("photo.png")
        let newImage = UIImage(contentsOfFile: imageURL.path) ?? nil
        if newImage != nil {
            photoPicture.image = newImage
        } else {
            photoPicture.image = UIImage(named: "GameLogo")
        }
    }
    
    private func setText(){
        guard let myString = logoText.text else { return  }
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let multipleAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.shadow:myShadow]
        let myAttrString = NSAttributedString(string: myString, attributes: multipleAttributes)
        logoText.attributedText = myAttrString
    }

    // MARK: - IBActions
    
   
    
    
    @IBAction func openAdditionalMenu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.blurView.isHidden = false
            self.menuWidth.constant = self.view.frame.width * 2 / 3
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        showAlert(title: "Start",
                   message: "Enter your PIN",
                   button: "OK",
                  secondButton: "Cancel",
                   textFieldHandler: { textField in
                   let pin = 5800
                   if textField.text == String(pin) {
                       self.showAlert(title: "Start",
                                      message: "PIN entered corectly",
                                      button: "OK"
                                      )
                   } else { self.showAlert(title: "Start",
                                           message: "PIN entered incorectly",
                                           button: "OK"
                                           )
                   }
        })
        
    }
    
    // MARK: - objc methods
    
    @objc private func dismissBlur(){
        UIView.animate(withDuration: 0.5) {
            self.blurView.isHidden = true
            self.menuWidth.constant = 0
            self.view.layoutIfNeeded()
        }
        }
}

