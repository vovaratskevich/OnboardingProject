//
//  OnboardingPageViewModel.swift
//  TestTask
//
//  Created by Vladimir Ratskevich on 21.10.21.
//

import Foundation

class OnboardinPageViewModel {
    
    lazy var onboardingArray: [Onboarding] = {
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
    
    private var contentViewModels: [OnboardingContentViewModel] = [OnboardingContentViewModel]()
    
    //MARK: - Functions
    
    func initVM() {
        createContentViewModels(onboardings: onboardingArray)
    }
    
    func createContentViewModels(onboardings: [Onboarding]) {
        for item in onboardings {
            self.contentViewModels.append(OnboardingContentViewModel(item: item))
        }
    }
    
    func getContentViewModel(at index: Int) -> OnboardingContentViewModel {
        return contentViewModels[index]
    }
    
}
