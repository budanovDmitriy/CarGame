//
//  AppSettings.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 31.03.2022.
//
import UIKit

struct User: Codable {
    let name: String
    let age: Int
}

enum Items: String {
    case stone
    case tree
    case rubish
}

class AppSettings {
    
    public static var shared = AppSettings()
    private init() { }
    
    var name: String {
        get {
            UserDefaults.standard.string(forKey: UDKeys.name.rawValue) ?? String()
        }
        set (newName) {
            
            UserDefaults.standard.set(newName, forKey: UDKeys.name.rawValue)
        }
    }
    
    func deleteName() {
        UserDefaults.standard.removeObject(forKey: UDKeys.name.rawValue)
    }
    
    var speed: Int {
        get {
            UserDefaults.standard.integer(forKey: UDKeys.speed.rawValue)
        }
        set (newSpeed) {
            
            UserDefaults.standard.set(newSpeed, forKey: UDKeys.speed.rawValue)
        }
    }
    
    var scores: [RaceResult] {
        get {
            guard let encodedData = UserDefaults.standard.array(forKey: UDKeys.score.rawValue) as? [Data] else {
                return []
            }
            return encodedData.map { try! JSONDecoder().decode(RaceResult.self, from: $0) }
        }
        set (newScore) {
            let data = newScore.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: UDKeys.score.rawValue)
        }
    }
    
    var bestScore: Int {
        get {
            UserDefaults.standard.integer(forKey: UDKeys.bestScore.rawValue)
        }
        set (newBestScore) {
            
            UserDefaults.standard.set(newBestScore, forKey: UDKeys.bestScore.rawValue)
        }
    }
    
    var carColor: UIColor {
        get {
            guard let data = UserDefaults.standard.data(forKey: UDKeys.color.rawValue) else { return UIColor() }
            
            let decoder = JSONDecoder()
            let decodedColor = try? decoder.decode(CodableColor.self, from: data).color
            
            return decodedColor ?? UIColor()
        }
        set (newCarColor) {
            
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(newCarColor.codable())

            UserDefaults.standard.set(encodedData, forKey: UDKeys.color.rawValue)
        }
    }
    
    var items:String {
        get {
            UserDefaults.standard.string(forKey: UDKeys.items.rawValue ) ?? ""
        }
        set (newItems) {
            UserDefaults.standard.set(newItems, forKey: UDKeys.items.rawValue)
        }
    }
    
    
   
    
    
    private enum UDKeys: String {
        case name
        case color
        case speed
        case items
        case score
        case bestScore
        case results
    }
}
