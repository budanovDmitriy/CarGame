//
//  GameViewController.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 10.04.2022.
//

import UIKit

class GameViewController: UIViewController {
    
    var isFirstLaunch = true
    var isFirstStart = true
    var isCrossed = false
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var barrierImage: UIImageView!
    
    @IBOutlet weak var carHeight: NSLayoutConstraint!
    @IBOutlet weak var carLeading: NSLayoutConstraint!
    
    @IBOutlet weak var barrierWidth: NSLayoutConstraint!
    @IBOutlet weak var barrierLeading: NSLayoutConstraint!
    @IBOutlet weak var barrierTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCarImage()
        
        if isCrossed == true {
            print("gameOver")
        }
    }
    
    private func startGame() {
        UIView.animate(withDuration: 10 / Double(AppSettings.shared.speed) ,
                       delay: 0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
            self.barrierTop.constant += self.view.frame.height
                           self.view.layoutIfNeeded()
        },
                       completion: {_ in
            self.barrierTop.constant -= self.view.frame.height
            self.barrierLeading.constant = self.setBarrierPosition()
            self.view.layoutIfNeeded()
            self.startGame()
        })
        
    }
    
    private func checkCrossing() {
        Timer.scheduledTimer(withTimeInterval: 0.01 , repeats: true) { timer in
            if self.carImage.frame.midX == self.barrierImage.frame.midX &&
                self.carImage.frame.midY == self.barrierImage.frame.midY {
                self.isCrossed.toggle()
                print("YYYEESSS")
            }
            if self.isCrossed == true {
                timer.invalidate()
            }
        }
    }
    
    private func setBarrierPosition()->CGFloat{
        let barrierPosition:[CGFloat] = [view.frame.width * 3 / 4  - barrierWidth.constant / 2, view.frame.width * 1 / 2  - barrierWidth.constant / 2, view.frame.width * 1 / 4  - barrierWidth.constant / 2]
        return barrierPosition.randomElement() ?? 0
    }
    
    private func setCarImage() {
        if isFirstLaunch == true {
            isFirstLaunch.toggle()
            carHeight.constant = view.frame.width / 4
            carLeading.constant = view.frame.width / 2 - carHeight.constant / 2
            barrierLeading.constant = view.frame.width / 2 - carHeight.constant / 2
            barrierWidth.constant = view.frame.width / 4
            switch AppSettings.shared.carColor {
            case .red: do {
                carImage.image? = UIImage(named: "red") ?? UIImage()
            }
            case .green: do {
                carImage.image? = UIImage(named: "green") ?? UIImage()
            }
            case .blue: do {
                carImage.image? = UIImage(named: "blue") ?? UIImage()
            }
        default: break
            }
            barrierImage.image? = UIImage(named: AppSettings.shared.items) ?? UIImage()
        }
    }
    
    @IBAction func rightSwipe(_ sender: Any) {
        if carLeading.constant < view.frame.width * 3 / 4  - carHeight.constant / 2 {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
            self.carLeading.constant += self.view.frame.width / 4
                           self.view.layoutIfNeeded()
        },
                       completion: {_ in
            
        })
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        while isFirstStart == true {
            startGame()
            isFirstStart.toggle()
            checkCrossing()
        }
    }
    
    
    @IBAction func leftSwipe(_ sender: Any) {
        if carLeading.constant > view.frame.width / 4 - carHeight.constant / 2 {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
            self.carLeading.constant -= self.view.frame.width / 4
                           self.view.layoutIfNeeded()
        },
                       completion: {_ in
        })
        }
    }
    
}
