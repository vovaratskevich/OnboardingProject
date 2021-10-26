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
    
    var imageName: String?
    var headerText: String?
    var descriptionText: String?
}
