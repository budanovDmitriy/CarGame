//
//  GameViewController.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 10.04.2022.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Private properties

    private var isFirstLaunch = true
    private var isFirstStart = true
    private var isCrossed = false
    private var currentScore = 0
    
    
    struct RaceResult {
        let name: String
        let score: Int
        let date: Date
        
        func getStringDate() -> String {
            let date = Date()

            
            let dateFormatter = DateFormatter()

            
            dateFormatter.dateFormat = "d, MMM YY, HH:mm:ss"

            
            
            return dateFormatter.string(from: date)
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var barrierImage: UIImageView!
    @IBOutlet weak var backgroungImage: UIImageView!
    
    @IBOutlet weak var carHeight: NSLayoutConstraint!
    @IBOutlet weak var carLeading: NSLayoutConstraint!
    
    @IBOutlet weak var barrierWidth: NSLayoutConstraint!
    @IBOutlet weak var barrierLeading: NSLayoutConstraint!
    @IBOutlet weak var barrierTop: NSLayoutConstraint!
    
    // MARK: - Override methods

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCarImage()
        scoreLabel.text = String(currentScore)
    }
    
    // MARK: - Private methods
    
    private func startGame() {
        if self.isCrossed != true {
            UIView.animate(withDuration: 30 / Double(AppSettings.shared.speed ),
                       delay: 0,
                       options: [.curveLinear],
                       animations: { [weak self] in
            self?.barrierTop.constant += (self?.view.frame.height ?? 0) - 50
            self?.view.layoutIfNeeded()
        },
                       completion: { [weak self] _ in
            self?.checkCrossing()
            self?.barrierTop.constant -= (self?.view.frame.height ?? 0) - 50
            self?.barrierLeading.constant = self?.setBarrierPosition() ?? 0
            if self?.isCrossed == false {
                self?.currentScore += 1
            } else {
                self?.currentScore = 0
            }
            self?.view.layoutIfNeeded()
            self?.startGame()
        })
        }
    }
    
    private func checkCrossing() {
        self.isCrossed = false
        let eps: CGFloat = 5
        if abs(self.carImage.frame.midX - self.barrierImage.frame.midX) < eps {
            self.isCrossed.toggle()
        }
        if self.isCrossed == true {
            AppSettings.shared.bestScore = max(AppSettings.shared.score,self.currentScore)
            AppSettings.shared.score = self.currentScore
            let result = RaceResult(name: AppSettings.shared.name, score: self.currentScore, date: .now)
            print(result)
            showAlert(title: "You score = \(self.currentScore)",
                       message: "Try one more time",
                      button: "OK",
                      handler: {_ in
                self.isCrossed.toggle()
                self.isFirstStart.toggle()
                self.currentScore = 0
            })
        }
    }
    
    private func setBarrierPosition()->CGFloat {
        let barrierPosition:[CGFloat] = [view.frame.width * 3 / 4  - barrierWidth.constant / 2, view.frame.width * 1 / 2  - barrierWidth.constant / 2, view.frame.width * 1 / 4  - barrierWidth.constant / 2]
        return barrierPosition.randomElement() ?? 0
    }
    
    private func setCarImage() {
        if isFirstLaunch == true {
            isFirstLaunch.toggle()
            self.barrierTop.constant = -50
            self.carHeight.constant = view.frame.width / 4
            self.carLeading.constant = view.frame.width / 2 - carHeight.constant / 2
            self.barrierLeading.constant = view.frame.width / 2 - carHeight.constant / 2
            self.barrierWidth.constant = view.frame.width / 4
            switch AppSettings.shared.carColor {
            case .red: self.carImage.image? = UIImage(named: "red") ?? UIImage()
            case .green: self.carImage.image? = UIImage(named: "green") ?? UIImage()
            case .blue: self.carImage.image? = UIImage(named: "blue") ?? UIImage()
            default: self.carImage.image? = UIImage(named: "blue") ?? UIImage()
            }
            self.barrierImage.image? = UIImage(named: AppSettings.shared.items) ?? UIImage(named: "stone") ?? UIImage()
        }
    }
    
    // MARK: - IBActions

    @IBAction func rightSwipe(_ sender: Any) {
        if carLeading.constant < view.frame.width * 3 / 4  - carHeight.constant / 2 {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [ .allowUserInteraction],
                       animations: { [weak self] in
            self?.carLeading.constant += (self?.view.frame.width ?? 0) / 4
            self?.view.layoutIfNeeded()
        })
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        while isFirstStart == true {
            startGame()
            isFirstStart.toggle()
        }
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        if carLeading.constant > view.frame.width / 4 - carHeight.constant / 2 {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [ .allowUserInteraction],
                       animations: { [weak self] in
            self?.carLeading.constant -= (self?.view.frame.width ?? 0) / 4
            self?.view.layoutIfNeeded()
        })
        }
    }
    
}
