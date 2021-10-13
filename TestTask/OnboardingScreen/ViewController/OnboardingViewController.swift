//
//  OnboardingViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 5.10.21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
// MARK: - Outlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var getStartButton: UIButton!
    
    var onboardingPageViewController: OnboardingPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        delegateCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? OnboardingPageViewController {
            onboardingPageViewController = pageViewController
        }
    }
}

// MARK: - Actions

extension OnboardingViewController {
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let index = onboardingPageViewController?.currentPageIndex {
            switch index {
            case 0...1:
                onboardingPageViewController?.forwardPage()
            case 2:
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
        updateUI()
    }
}

// MARK: - View

extension OnboardingViewController {
    
    private func configureView() {
        //navigationController?.navigationBar.isHidden = true
        //onboardingPageViewController?.onboardingDelegate = self
        
        nextButton.layer.cornerRadius = 10
        skipButton.layer.cornerRadius = 10
        getStartButton.layer.cornerRadius = 10
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor.red.cgColor
    }
    
    func updateUI() {
        if let index = onboardingPageViewController?.currentPageIndex {
            switch index {
            case 0...1:
                animateHiddenButton(with: nextButton, isHidden: false)
                animateHiddenButton(with: skipButton, isHidden: false)
                getStartButton.isHidden = true
            case 2:
                nextButton.isHidden = true
                skipButton.isHidden = true
                animateHiddenButton(with: getStartButton, isHidden: false)
            default:
                break
            }
            pageControl.currentPage = index
        }
    }
    
    private func animateHiddenButton(with button: UIButton, isHidden: Bool) {
        UIView.transition(with: button, duration: 0.5, options: .transitionCrossDissolve, animations: {button.isHidden = isHidden}, completion: nil)
    }
}

// MARK: - DelegateCallback

extension OnboardingViewController {
    
    func delegateCallback() {
        onboardingPageViewController?.didUpdatePageIndex = { [weak self] currentPageIndex in
            self?.updateUI()
        }
    }
}



// MARK: - OnboardingPageViewControllerDelegate

//extension OnboardingViewController: OnboardingPageViewControllerDelegate {
//
//    func didUpdatePageIndex(currentPageIndex: Int) {
//        updateUI()
//    }
//}


