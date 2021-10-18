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
    @IBOutlet weak var hiddenMaskButton: UIButton!
    
    var onboardingPageViewController: OnboardingPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        configureView()
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
        let maskButton = UIButton()
        skipButton.updateFocusIfNeeded()
        maskButton.frame = skipButton.bounds
        maskButton.setTitle(skipButton.titleLabel?.text, for: .normal)
        maskButton.titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 17)
        maskButton.layer.cornerRadius = 10
        maskButton.layer.borderWidth = 1
        skipButton.mask = maskButton
        
        configureGradientButton(with: skipButton)
        configureGradientButton(with: nextButton)
        configureGradientButton(with: getStartButton)
    }
    
    func configureGradientButton(with button: UIButton) {
        button.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor(red: 1, green: 0.408, blue: 0, alpha: 1).cgColor,
                                UIColor(red: 1, green: 0.278, blue: 0.094, alpha: 1).cgColor,
                                UIColor(red: 1, green: 0.161, blue: 0.18, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        if button == nextButton || button == getStartButton {
            button.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            button.layer.addSublayer(gradientLayer)
        }
        button.layer.masksToBounds = true
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 17)
    }
    
    private func updateUI() {
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



