//
//  OnboardingScrollViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 2.11.21.
//

import UIKit
import SnapKit
import Bond

class ScrollViewController: UIViewController {
    
    private lazy var onboardingScrollView = UIScrollView()
    private lazy var onboardingPageControl = UIPageControl()
    private lazy var onboardingNextButton = UIButton()
    private lazy var onboardingSkipButton = UIButton()
    private lazy var onboardingGetStartButton = UIButton()
    
    private lazy var viewModel: OnboardinPageViewModel = {
        return OnboardinPageViewModel()
    }()
    
    private var pageCount = 0
    private var currentPage = 0
    
    private var scrollWidth: CGFloat = 0.0
    private var scrollHeight: CGFloat = 0.0
    
    private var lastVelocityYSign = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.layoutIfNeeded()
        
        print("didLoad")
        
        viewModel.createContentViewModels()

        pageCount = viewModel.onboardingArray.count
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<pageCount {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slideViewController = ScrollContentViewController()
            slideViewController.viewModel = viewModel.getContentViewModel(at: index)
            
            slideViewController.view.frame = frame

            onboardingScrollView.addSubview(slideViewController.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollWidth = onboardingScrollView.frame.size.width
        scrollHeight = onboardingScrollView.frame.size.height
        configureView()
        addConstraints()
    }
}

//MARK: - ViewSetting

private extension ScrollViewController {
    
    func configureView() {
        onboardingScrollView.delegate = self
        onboardingScrollView.backgroundColor = .white
        onboardingScrollView.contentInsetAdjustmentBehavior = .never
        onboardingScrollView.isPagingEnabled = true
        onboardingScrollView.showsVerticalScrollIndicator = false
        onboardingScrollView.showsHorizontalScrollIndicator = false
        onboardingScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(pageCount), height: scrollHeight)
        onboardingScrollView.contentSize.height = 1.0
        
        onboardingPageControl.numberOfPages = pageCount
        onboardingPageControl.currentPage = currentPage
        onboardingPageControl.currentPageIndicatorTintColor = .red
        onboardingPageControl.pageIndicatorTintColor = .lightGray
        onboardingPageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        onboardingNextButton.layer.cornerRadius = 10
        onboardingNextButton.setTitle("Далее", for: .normal)
        onboardingNextButton.backgroundColor = .orange
        configureGradientButton(with: onboardingNextButton)
        onboardingNextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        let maskButton = UIButton()
        maskButton.frame = onboardingSkipButton.bounds
        maskButton.layer.borderWidth = 1
        maskButton.layer.cornerRadius = 10
        maskButton.setTitle(onboardingSkipButton.titleLabel?.text, for: .normal)
        maskButton.titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 17)
        onboardingSkipButton.mask = maskButton
        onboardingSkipButton.setTitle("Пропустить", for: .normal)
        configureGradientButton(with: onboardingSkipButton)
        onboardingSkipButton.addTarget(self, action: #selector(moveToHomeScreen), for: .touchUpInside)
        
        onboardingGetStartButton.layer.cornerRadius = 10
        onboardingGetStartButton.setTitle("Начать пользоваться", for: .normal)
        onboardingGetStartButton.backgroundColor = .orange
        onboardingGetStartButton.isHidden = true
        configureGradientButton(with: onboardingGetStartButton)
        onboardingGetStartButton.addTarget(self, action: #selector(moveToHomeScreen), for: .touchUpInside)
        
        view.backgroundColor = .white
        
        [onboardingScrollView, onboardingPageControl, onboardingNextButton, onboardingSkipButton, onboardingGetStartButton].forEach {
            view.addSubview($0)
        }
    }
    
    func configureGradientButton(with button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor(red: 1, green: 0.408, blue: 0, alpha: 1).cgColor,
                                UIColor(red: 1, green: 0.278, blue: 0.094, alpha: 1).cgColor,
                                UIColor(red: 1, green: 0.161, blue: 0.18, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        if button == onboardingSkipButton {
            button.layer.addSublayer(gradientLayer)
        } else {
            button.layer.insertSublayer(gradientLayer, at: 0)
        }
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 17)
    }
    
    func addConstraints() {
        onboardingScrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(onboardingPageControl.snp.top).inset(-7.5)
        }
        
        onboardingPageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(96.0)
            make.bottom.equalTo(onboardingNextButton.snp.top).inset(-7.5)
        }

        onboardingNextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(onboardingSkipButton.snp.top).inset(-20.0)
            make.height.equalTo(onboardingNextButton.snp.width).dividedBy(343.0/46.0)
        }

        onboardingSkipButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15.0)
            make.height.equalTo(onboardingSkipButton.snp.width).dividedBy(343.0/46.0)
        }
        
        onboardingGetStartButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50.0)
            make.height.equalTo(onboardingGetStartButton.snp.width).dividedBy(343.0/46.0)
        }
    }
    
    func updateUI() {
        switch currentPage {
        case pageCount - 1:
            onboardingNextButton.isHidden = true
            onboardingSkipButton.isHidden = true
            animateHiddenButton(with: onboardingGetStartButton, isHidden: false)
        default:
            animateHiddenButton(with: onboardingNextButton, isHidden: false)
            animateHiddenButton(with: onboardingSkipButton, isHidden: false)
            onboardingGetStartButton.isHidden = true
        }
    }
    
    func animateHiddenButton(with button: UIButton, isHidden: Bool) {
        UIView.transition(with: button, duration: 0.5, options: [.allowUserInteraction, .transitionCrossDissolve], animations: { button.isHidden = isHidden }, completion: nil)
    }
}

//MARK: - Mrthods&Actions

private extension ScrollViewController {
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        currentPage += 1
        onboardingPageControl.currentPage = currentPage
        onboardingScrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        updateUI()
    }
    
    @objc func moveToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        onboardingScrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        updateUI()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (onboardingScrollView.contentOffset.x)/scrollWidth
        currentPage = Int(page)
        onboardingPageControl.currentPage = currentPage
    }
}

//MARK: - UIScrollViewDelegate

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
        updateUI()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).x
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign && currentVelocityY != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            switch currentPage {
            case pageCount - 1:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                navigationController?.pushViewController(homeViewController, animated: true)
            default:
                break
            }
        }
    }
}
