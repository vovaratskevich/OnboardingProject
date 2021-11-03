//
//  OnboardingContentViewModel.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 20.10.21.
//

import Foundation

class OnboardingContentViewModel {
    
    init(item: Onboarding) {
        self.headerText = item.headerText
        self.descriptionText = item.descriptionText
        self.imageName = item.imageName
    }
    
    private(set) var imageName: String?
    private(set) var headerText: String?
    private(set) var descriptionText: String?
}
