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

extension UIStackView {
    func setStackView(axis: NSLayoutConstraint.Axis, distribution: Distribution, spacing: CGFloat){
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
}

extension UIView {
    func setLeadingLabel(withTitle Title:String){
        let label = UILabel()
        label.text = Title
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setTrailingLabel(withTitle Title:String){
        let label = UILabel()
        label.text = Title
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
}

extension UIColor {
    
    static let oliveGreen = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1)
    static let skyBlue = UIColor(red: 201/255, green: 233/255, blue: 246/255, alpha: 1)
}

extension UIButton {
    func setButton(withTitle title: String, bgColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.layer.cornerRadius = 15
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = true
        self.titleLabel?.textAlignment = .center
    }
    
    func setStackViewButton(withTitle title: String, bgColor: UIColor,  cornerRadius: CGFloat){
        self.setButton(withTitle: title, bgColor: bgColor)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = cornerRadius
    }
}
