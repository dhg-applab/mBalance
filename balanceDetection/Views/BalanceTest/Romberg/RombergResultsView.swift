//
//  RombergResultsView.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.07.21.
//

import UIKit

class RombergResultsView: UIViewController {
    
    var eyesOpenResult: Int
    var eyesClosedResult: Int
    
    init(eyesOpen: Int, eyesClosed: Int) {
        eyesOpenResult = eyesOpen
        eyesClosedResult = eyesClosed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        
        eyesOpenResultLabel.text = "\(eyesOpenResult)"
        eyesClosedResultLabel.text = "\(eyesClosedResult)"
    
        view.addSubview(navBarExtensionView)
        view.addSubview(bottomTitleLabel)
        view.addSubview(vStack)
        
        vStack.addArrangedSubview(eyesOpenLabel)
        vStack.addArrangedSubview(eyesOpenResultLabel)
        vStack.addArrangedSubview(eyesClosedLabel)
        vStack.addArrangedSubview(eyesClosedResultLabel)
        
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
            
            vStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            vStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            vStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 100),
            vStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -100)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.navigationItem.titleView = topTitleLabel
    }
    
    //MARK: UI-Elements
    
    var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance                  "
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .left
        return label
    }()

    var bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Results"
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
    
    var vStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.distribution = .equalCentering
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var eyesOpenLabel: UILabel = {
        var label = UILabel()
        label.text = "Seconds with eyes open:"
        label.font = .systemFont(ofSize: 25)
        label.textColor = UIColor(named: "FontColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var eyesClosedLabel: UILabel = {
        var label = UILabel()
        label.text = "Seconds with eyes closed:"
        label.font = .systemFont(ofSize: 25)
        label.textColor = UIColor(named: "FontColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var eyesOpenResultLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = UIColor(named: "FontColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var eyesClosedResultLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = UIColor(named: "FontColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
