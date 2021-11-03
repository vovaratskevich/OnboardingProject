//
//  ScrollContentViewController.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 2.11.21.
//

import UIKit
import SnapKit

class ScrollContentViewController: UIViewController {
    
    // MARK: - Properies
    
    private lazy var contentImageView = UIImageView()
    private lazy var contentSubView = UIView()
    private lazy var contentStackView = UIStackView()
    private lazy var contentHeaderLabel = UILabel()
    private lazy var contentDescriptionLabel = UILabel()
    private lazy var contentEmptyLabel = UILabel()
    
    var viewModel: OnboardingContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData(viewModel: viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureView()
        addConstraints()
    }
}

private extension ScrollContentViewController {
    
    func configureView() {
        contentSubView.layer.cornerRadius = 24
        contentSubView.backgroundColor = .white
        
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 12
        
        contentHeaderLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
        contentHeaderLabel.font = UIFont(name: "TTNorms-Medium", size: 25)
        contentHeaderLabel.numberOfLines = 0
        contentHeaderLabel.lineBreakMode = .byWordWrapping
        contentHeaderLabel.textAlignment = .center
        
        contentDescriptionLabel.textColor = UIColor(red: 0.094, green: 0.136, blue: 0.179, alpha: 1)
        contentDescriptionLabel.font = UIFont.systemFont(ofSize: 15.0)
        contentDescriptionLabel.numberOfLines = 0
        contentDescriptionLabel.textAlignment = .center
        
        [contentImageView, contentSubView, contentStackView].forEach {
            view.addSubview($0)
        }
        
        [contentHeaderLabel, contentDescriptionLabel, contentEmptyLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    func addConstraints() {
        contentImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentImageView.snp.width).multipliedBy(430.0/375.0)
            make.bottom.equalTo(contentSubView.snp.top).inset(32)
        }
        
        contentSubView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(contentSubView.snp.top).inset(32)
            make.left.right.equalTo(contentSubView).inset(16)
            make.bottom.equalTo(contentSubView.snp.bottom)
        }
        
        contentHeaderLabel.snp.contentHuggingVerticalPriority = 252
        contentDescriptionLabel.snp.contentHuggingVerticalPriority = 251
        contentEmptyLabel.snp.contentHuggingVerticalPriority = 250
    }
    
    func setData(viewModel: OnboardingContentViewModel?) {
        guard let imageName = UIImage(named: viewModel?.imageName ?? "nil") else { return }
        guard let headerText = viewModel?.headerText else { return }
        guard let descriptionText = viewModel?.descriptionText else { return }
        contentImageView.image = imageName
        contentHeaderLabel.text = headerText
        contentDescriptionLabel.text = descriptionText
    }
}

