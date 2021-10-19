//
//  OnboardingContentViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 5.10.21.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var childView: UIView!
    
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

    private var headerText: String = "nil"
    private var descriptionText: String = "nil"
    private var imageName: String = "nil"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

extension OnboardingContentViewController {
    
    private func configureView() {
        imageView.image = UIImage(named: imageName)
        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
        
        childView.layer.cornerRadius = 24
        
        headerLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
        headerLabel.font = UIFont(name: "TTNorms-Medium", size: 25)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
    }
    
    func setViewData(_ item: Onboarding) {
        self.headerText = item.headerText
        self.descriptionText = item.descriptionText
        self.imageName = item.imageName
    }
}
