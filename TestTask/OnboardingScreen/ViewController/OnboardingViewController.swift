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
        
        delegateCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

private extension OnboardingViewController {
    
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
            default:
                break
            }
        }
        updateUI()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        onboardingPageViewController?.setPage(index: sender.currentPage)
        updateUI()
    }
}

// MARK: - View

extension OnboardingViewController {
    
    private func configureView() {
        let maskButton = UIButton()
        maskButton.frame = skipButton.bounds
        maskButton.layer.borderWidth = 1
        maskButton.layer.cornerRadius = 10
        maskButton.setTitle(skipButton.titleLabel?.text, for: .normal)
        maskButton.titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 17)
        skipButton.mask = maskButton
        
        configureGradientButton(with: skipButton)
        configureGradientButton(with: nextButton)
        configureGradientButton(with: getStartButton)
    }
    
    private func configureGradientButton(with button: UIButton) {
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
        button.layer.cornerRadius = 10
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



