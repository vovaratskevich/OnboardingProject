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
    
    var index = 0
    private var headerText = "nil"
    private var descriptionText = "nil"
    private var imageName = "nil"
    
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
    
//    private func layout() {
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        childView.translatesAutoresizingMaskIntoConstraints = false
//        //lableStackView.translatesAutoresizingMaskIntoConstraints = false
//
//
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.topAnchor),
//            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 1.89),
//
//            childView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            childView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            childView.heightAnchor.constraint(equalToConstant: view.bounds.height / 1.99),
//        ])
//    }
    
    func updateData(item: Onboarding) {
        headerText = item.headerText 
        descriptionText = item.descriptionText 
        imageName = item.imageName 
    }
}
