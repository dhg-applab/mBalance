//
//  MMTRoundImage.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 27.05.21.
//

import Foundation
import UIKit

class MMTRoundImage: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(named: "BackgroundSecondary")?.cgColor
        self.layer.borderWidth = 10
    }
}
