//
//  IntroPageViewControllerOne.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.06.21.
//

import Foundation
import UIKit

class IntroPageViewControllerOne: UIViewController {
    
    //- initial stand
    
    let index = 1
    
    func getIndex() -> Int {
        return index
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        
        view.addSubview(imageView)
        view.addSubview(textView)
        
        self.navigationItem.titleView = titleLabel
        
        let guide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: guide.centerYAnchor, constant: -90),
            imageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -5),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),
            textView.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: -20),
            textView.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "IntroOne")
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test setup"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.text = "During the Romberg test you have to stand with your face facing the camera. Put your feet as close together as you can and cross your arms in front of your body. It is important that your hands are still visible to the camera. See the picture above for reference. Try to stay in this position until the test is finished, but do not worry if you loose balance!"
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .justified
        view.isUserInteractionEnabled = false
        return view
    }()
    
}
