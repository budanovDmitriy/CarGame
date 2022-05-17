//
//  RaceResult.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 22.04.2022.
//

import Foundation

struct RaceResult: Codable {
    let name: String
    let score: Int
    let date: Date
    
    func getStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM HH:mm:ss"
        return dateFormatter.string(from: date)
    }

}
