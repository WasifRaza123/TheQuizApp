//
//  Extension.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 09/11/23.
//

import Foundation
import UIKit

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil) { // this method adds shadow to right and bottom side of button
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func setAllSideShadow(shadowShowSize: CGFloat = 1.0) { // this method adds shadow to allsides
        let shadowSize : CGFloat = shadowShowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.withAlphaComponent(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    
}

extension UIStackView {
    func setStackView(axis: NSLayoutConstraint.Axis, distribution: Distribution, spacing: CGFloat){
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
}

extension UIColor {
    
    static let oliveGreen = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1)
    static let skyBlue = UIColor(red: 201/255, green: 233/255, blue: 246/255, alpha: 1)
}
