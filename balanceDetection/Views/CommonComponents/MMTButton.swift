//
//  MMTButton.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 27.05.21.
//

import Foundation
import UIKit

final class MMTButton: UIButton {

    var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
            setTitleColor(UIColor(named: "FontColor"), for: .normal)
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor(named: "BackgroundSecondary")?.cgColor
    }
    
}
