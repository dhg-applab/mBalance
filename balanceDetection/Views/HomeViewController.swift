//
//  HomeViewController.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 17.05.21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        
        // Do any additional setup after loading the view.
    
        view.addSubview(navBarExtensionView)
        view.addSubview(bottomTitleLabel)
        view.addSubview(resultsButton)
        view.addSubview(roundIconView)
        view.addSubview(startButton)
        view.addSubview(descriptionView)
        
        let guide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            navBarExtensionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            navBarExtensionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            navBarExtensionView.topAnchor.constraint(equalTo: guide.topAnchor),
            navBarExtensionView.heightAnchor.constraint(equalToConstant: 60),
            
            bottomTitleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            bottomTitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            bottomTitleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            bottomTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            resultsButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -100),
            resultsButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 100),
            resultsButton.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: -100),
            resultsButton.heightAnchor.constraint(equalToConstant: 50),
            
            startButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            startButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            startButton.topAnchor.constraint(equalTo: guide.centerYAnchor, constant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 80),
            
            roundIconView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            roundIconView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80),
            roundIconView.heightAnchor.constraint(equalToConstant: 200),
            roundIconView.widthAnchor.constraint(equalToConstant: 200),
            
            descriptionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            descriptionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            descriptionView.topAnchor.constraint(equalTo: roundIconView.bottomAnchor, constant: 20),
            descriptionView.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.navigationItem.titleView = topTitleLabel
        
    }
    
    //MARK: UI-Elements
    
    var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to                        "
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .left
        return label
    }()

    var bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "the Balance Test!"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var navBarExtensionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var resultsButton: MMTButton = {
        let button = MMTButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleText = "See results"
        button.addTarget(self, action: #selector(showDiaryView), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    var roundIconView: MMTRoundImage = {
        let icon = MMTRoundImage()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "balanceImage")
        return icon
    }()
    
    var startButton: MMTButton = {
        let button = MMTButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleText = "Start test"
        button.addTarget(self, action: #selector(showRombergView), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        return button
    }()
    
    var descriptionView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.text = "The Romberg test is an effective tool for measuring balance."
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        view.font = .systemFont(ofSize: 20)
        view.textAlignment = .justified
        return view
    }()
    
    
    //MARK: Button action
    
    @objc func showDiaryView() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
    }
    
    @objc func showRombergView() {
        navigationController?.pushViewController(IntroductionPageViewController(), animated: true)
    }
}
