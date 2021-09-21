//
//  IntroPageViewControllerTwo.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.06.21.
//

import Foundation
import UIKit

class IntroPageViewControllerTwo: UIViewController {
    
    //- 2*60s + measurement
    
    let index = 2
    
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
        view.image = UIImage(named: "IntroTwo")
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
        view.text = "The Romberg test consists of two parts, each taking a maximum of 60 seconds. After you started the test, you will have to take the test position. The app will recognise automatically if you positioned yourself correctly. For the first 60 seconds you stand with eyes open. After the first part of the test you will have to keep your position and close your eyes. Keep the position with eyes closed until the test is finished. If you cannot hold the test position because you loose balance, the test will be finished early. The test results are the two values of how long you were able to hold your balance with eyes open and eyes closed."
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .justified
        view.isUserInteractionEnabled = false
        return view
    }()
}
