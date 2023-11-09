//
//  PaddingLabel.swift
//  Quiz
//
//  Created by Mohd Wasif Raza on 09/11/23.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
        var leftInset: CGFloat = 16.0
        var rightInset: CGFloat = 16.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: 0.0, left: leftInset, bottom: 0.0, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height )
        }
}
