//
//  OnboardingPageViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 5.10.21.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    var didUpdatePageIndex: ((Int) -> Void)?
    
    var currentPageIndex = 0
    
    private var lastVelocityYSign = 0
    
    private(set) lazy var onboardingArray: [Onboarding] = {
        return [Onboarding(imageName: "onboarding-1",
                           headerText: "Узнавай первым о всех акциях и мероприятиях",
                           descriptionText: "Все мероприятия, шоу и встречи Острова Мечты"),
                Onboarding(imageName: "onboarding-2",
                           headerText: "Покупай билеты легко!",
                           descriptionText: "Выберай дату, тип и количество билетов и оплачивайте  одной кнопкой"),
                Onboarding(imageName: "onboarding-3",
                           headerText: "Управляй своими билетами и бонусами",
                           descriptionText: "В профиле сохраняется история всех ваших покупок")]
    }()
     
    private lazy var pages: [UIViewController?] = {
        return [contentViewController(at: 0),
                contentViewController(at: 1),
                contentViewController(at: 2)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func contentViewController(at index: Int) -> UIViewController? {
        if index < 0 || index == onboardingArray.count { return nil }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController else { return nil}
        pageContentViewController.setViewData(onboardingArray[index])
        return pageContentViewController
    }
    
    func setPage(index: Int) {
        if let nextViewController = pages[index] {
            if currentPageIndex < index {
                setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            } else {
                setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
            }
        }
        currentPageIndex = index
    }

    func forwardPage() {
        currentPageIndex += 1
        if let nextViewController = pages[currentPageIndex] {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func previsiusPage() {
        currentPageIndex -= 1
        if let nextViewController = pages[currentPageIndex] {
            setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
}

private extension OnboardingPageViewController {
    
    func configureView() {
        self.dataSource = self
        self.delegate = self
        
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.delegate = self
            }
        }
        
        if let startingViewController = pages[0] {
            if let index = pages.firstIndex(of: startingViewController as? OnboardingContentViewController) {
                currentPageIndex = index
            }
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 { return nil } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else { return nil }
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController:  UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = pages.firstIndex(of: pageViewController.viewControllers?.first as? OnboardingContentViewController) {
                currentPageIndex = index
                self.didUpdatePageIndex?(currentPageIndex)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingPageViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).x
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign && currentVelocityY != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            switch currentPageIndex {
            case 2:
                if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    navigationController?.pushViewController(homeViewController, animated: true)
                }
            default:
                break
            }
        }
    }
}
  
