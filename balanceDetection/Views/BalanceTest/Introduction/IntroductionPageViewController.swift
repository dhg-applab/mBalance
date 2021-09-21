//
//  IntroductionPageViewController.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 01.06.21.
//

import Foundation
import UIKit

class IntroductionPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundPrimary")
        pageControl.numberOfPages = allPagesByIndex.count
        
        view.addSubview(pageControl)
        
        self.navigationItem.titleView = topTitleLabel
        
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([allPagesByIndex[0]], direction: .forward, animated: true, completion: nil)
        
        let guide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            pageControl.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -5),
            pageControl.widthAnchor.constraint(equalTo: guide.widthAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        view.bringSubviewToFront(pageControl)
    }
    
    //MARK: UI-Elements
    
    var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Introduction"
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .left
        return label
    }()
    
    var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.frame = CGRect()
        control.currentPageIndicatorTintColor = UIColor(named: "FontColor")
        control.pageIndicatorTintColor = UIColor(named: "BackgroundSecondary")
        control.backgroundColor = UIColor(named: "BackgroundPrimary")
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    
    //MARK: for controlling the page view
    var currentIndex = 0
    var allPagesByIndex = [IntroPageViewControllerZero(), IntroPageViewControllerOne(), IntroPageViewControllerTwo(), IntroPageViewControllerThree()]
}

extension IntroductionPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore: UIViewController) -> UIViewController? {
        if(currentIndex == 0) {
            return nil
        } else {
            currentIndex = currentIndex - 1
            return allPagesByIndex[currentIndex]
        }
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter: UIViewController) -> UIViewController? {
        if(currentIndex == allPagesByIndex.count - 1) {
            return nil
        } else {
            currentIndex = currentIndex + 1
            return allPagesByIndex[currentIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.allPagesByIndex.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    func presentationCount(for: UIPageViewController) -> Int {
        return allPagesByIndex.count
    }
    
    func presentationIndex(for: UIPageViewController) -> Int {
        return currentIndex
    }

}

extension IntroductionPageViewController: UIPageViewControllerDelegate {

}

