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
    
    var lastVelocityYSign = 0
    
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
    
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func contentViewController(at index: Int) -> UIViewController? {
        if index < 0 || index == onboardingArray.count { return nil }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController
        pageContentViewController?.updateData(item: onboardingArray[index])
        pageContentViewController?.index = index
        return pageContentViewController
    }

    func forwardPage() {
        currentPageIndex += 1
        if let nextViewController = contentViewController(at: currentPageIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func previsiusPage() {
        currentPageIndex -= 1
        if let nextViewController = contentViewController(at: currentPageIndex) {
            setViewControllers([nextViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
}

extension OnboardingPageViewController {
    
    private func configureView() {
        
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.delegate = self
            }
        }

        self.dataSource = self
        self.delegate = self
        if let startingViewController = contentViewController(at: 0) {
            currentPageIndex = (startingViewController as? OnboardingContentViewController)!.index
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? OnboardingContentViewController)?.index else { return nil}
        let before = index - 1

        return contentViewController(at: before)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? OnboardingContentViewController)?.index else { return nil}
        let after = index + 1
        
        return contentViewController(at: after)
    }
}

// MARK: - DelegateCall

extension OnboardingPageViewController:  UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentPageIndex = contentViewController.index
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
