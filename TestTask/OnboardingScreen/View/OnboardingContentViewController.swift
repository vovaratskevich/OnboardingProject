//
//  OnboardingContentViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 5.10.21.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak  private var descriptionLabel: UILabel!
    @IBOutlet weak  private var childView: UIView!
    
    //    init?(coder: NSCoder, index: Int, item: Onboarding) {
    //        self.index = index
    //        self.headerText = item.headerText
    //        self.descriptionText = item.descriptionText
    //        self.imageName = item.imageName
    //        super.init(coder: coder)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    var viewModel: OnboardingContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData(viewModel: viewModel)
        configureView()
    }
}

private extension OnboardingContentViewController {
    
    func configureView() {
        childView.layer.cornerRadius = 24
        childView.layer.cornerRadius = 24
        childView.layer.cornerRadius = 24
        childView.layer.cornerRadius = 24
        childView.layer.cornerRadius = 24
        
        headerLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
        headerLabel.font = UIFont(name: "TTNorms-Medium", size: 25)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
    }
    
    func setData(viewModel: OnboardingContentViewModel?) {
        guard let imageName = UIImage(named: viewModel?.imageName ?? "nil") else { return }
        guard let headerText = viewModel?.headerText else { return }
        guard let descriptionText = viewModel?.descriptionText else { return }
        imageView.image = imageName
        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
    }
}
