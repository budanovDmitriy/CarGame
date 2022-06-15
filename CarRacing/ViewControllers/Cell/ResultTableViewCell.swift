//
//  ResultTableViewCell.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 15.06.2022.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var rxResult: RaceResult! {
        didSet {
            setResultData()
        }
    }

    private func setResultData() {
        
        nameLbl.text = rxResult.name
        scoreLbl.text = String( rxResult.score)
        dateLbl.text = rxResult.getStringDate()
    }
}
