//
//  Colar + Codable.swift
//  CarRacing
//
//  Created by Dmitriy Budanov on 31.03.2022.
//

import UIKit

/// Allows you to use Swift encoders and decoders to process UIColor
public struct CodableColor {
    
    /// The color to be (en/de)coded
    let color: UIColor
}



extension CodableColor: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}



extension CodableColor: Decodable {
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        self.color = try UIColor(coder: nsCoder).unsafelyUnwrapped
    }
}



public extension UIColor {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}

