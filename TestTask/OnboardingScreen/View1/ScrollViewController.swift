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
    
    private lazy var viewModel: OnboardinPageViewModel = {
        return OnboardinPageViewModel()
    }()
    
    private var pageCount = 0
    
    private var scrollWidth: CGFloat = 0.0
    private var scrollHeight: CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        scrollWidth = onboardingScrollView.frame.size.width
        scrollHeight = onboardingScrollView.frame.size.height
        configureView()
        addConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.layoutIfNeeded()
        
        viewModel.initVM()

        pageCount = viewModel.onboardingArray.count
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<pageCount {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let slideViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController else { return }
            slideViewController.viewModel = viewModel.getContentViewModel(at: index)
            
            slideViewController.view.frame = frame

            onboardingScrollView.addSubview(slideViewController.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
}

private extension ScrollViewController {
    
    func configureView() {
        onboardingScrollView.delegate = self
        onboardingScrollView.backgroundColor = .white
        onboardingScrollView.contentInsetAdjustmentBehavior = .never
        onboardingScrollView.isPagingEnabled = true
        onboardingScrollView.showsVerticalScrollIndicator = false
        //onboardingScrollView.showsHorizontalScrollIndicator = false
        onboardingScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(pageCount), height: scrollHeight)
        onboardingScrollView.contentSize.height = 1.0
        
        onboardingPageControl.numberOfPages = 3
        onboardingPageControl.currentPage = 0
        onboardingPageControl.currentPageIndicatorTintColor = .red
        onboardingPageControl.pageIndicatorTintColor = .lightGray
        
        onboardingNextButton.layer.cornerRadius = 10
        onboardingNextButton.setTitle("Далее", for: .normal)
        onboardingNextButton.backgroundColor = .orange
        
        onboardingSkipButton.layer.cornerRadius = 10
        onboardingSkipButton.setTitle("Пропустить", for: .normal)
        onboardingSkipButton.backgroundColor = .orange
        
        view.backgroundColor = .white
        
        [onboardingScrollView, onboardingPageControl, onboardingNextButton, onboardingSkipButton].forEach {
            view.addSubview($0)
        }
    }
    
    func addConstraints() {
        onboardingScrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(onboardingPageControl.snp.top).inset(-7.5)
        }
        
        onboardingPageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(96)
            make.bottom.equalTo(onboardingNextButton.snp.top).inset(-7.5)
        }

        onboardingNextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(onboardingSkipButton.snp.top).inset(-20)
            make.height.equalTo(onboardingNextButton.snp.width).dividedBy(343/46)
        }

        onboardingSkipButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(onboardingSkipButton.snp.width).dividedBy(343/46)
        }
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
}
