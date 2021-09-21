//
//  IntroPageViewControllerThree.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.06.21.
//

import Foundation
import UIKit

class IntroPageViewControllerThree: UIViewController {
    
    //- audio feedback -> position your phone now

    let index = 3
    
    func getIndex() -> Int {
        return index
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        
        view.addSubview(imageView)
        view.addSubview(textView)
        view.addSubview(startButton)
        
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
            textView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            startButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            startButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            startButton.topAnchor.constraint(equalTo: guide.centerYAnchor, constant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 80),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: UI-Elements
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "IntroThree")
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
        view.text = "As your phone's screen is not available during the test, the app will guide you through the test with audio feedback. As soon as you started the test, the app will tell you each step, like taking the test position, telling you when to close your eyes, and when you can open them again. Start the test now and position your phone!"
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        view.font = .systemFont(ofSize: 15)
        view.textAlignment = .justified
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var startButton: MMTButton = {
        let button = MMTButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleText = "Start test"
        button.addTarget(self, action: #selector(showRombergView), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        return button
    }()
    
    //MARK: Button action
    
    @objc func showRombergView() {
        navigationController?.pushViewController(RombergViewController(), animated: true)
    }
}
