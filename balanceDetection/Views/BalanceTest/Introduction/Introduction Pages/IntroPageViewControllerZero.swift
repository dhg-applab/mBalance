//
//  IntroPageViewControllerZero.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.06.21.
//

import Foundation
import UIKit

class IntroPageViewControllerZero: UIViewController {
    
    //- Phone position, start with watch
    
    let index = 0
    
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
        view.image = UIImage(named: "IntroZero")
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
        view.text = "To conduct the test, you have to position the phone in a way that the rear-faced camera can film your whole body. You can see an example for that in the picture above. When your camera is set up, the test will start automatically when you are standing in the right position."
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .justified
        view.isUserInteractionEnabled = false
        return view
    }()
    
}
