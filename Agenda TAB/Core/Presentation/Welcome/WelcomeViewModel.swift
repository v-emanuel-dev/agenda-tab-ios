import Foundation
import SwiftUI
import Combine

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var currentStep = 0
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "is_first_launch"
    private let welcomeCompletedKey = "welcome_completed"
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        let isFirstLaunch = userDefaults.bool(forKey: firstLaunchKey)
        let welcomeCompleted = userDefaults.bool(forKey: welcomeCompletedKey)
        
        self.isFirstLaunch = !isFirstLaunch || !welcomeCompleted
    }
    
    func nextStep() {
        if currentStep < 3 {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func setStep(_ step: Int) {
        if step >= 0 && step <= 3 {
            currentStep = step
        }
    }
    
    func completeWelcome() {
        userDefaults.set(true, forKey: firstLaunchKey)
        userDefaults.set(true, forKey: welcomeCompletedKey)
        isFirstLaunch = false
    }
    
    func resetWelcome() {
        userDefaults.set(false, forKey: firstLaunchKey)
        userDefaults.set(false, forKey: welcomeCompletedKey)
        isFirstLaunch = true
        currentStep = 0
    }
}
