import SwiftUI

struct ContentView: View {
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    @StateObject private var calendarViewModel: CalendarViewModel
    
    init() {
        let repository = MoodRepositoryImpl()
        let getDailyEntriesUseCase = GetDailyEntriesUseCase(repository: repository)
        let saveDailyEntryUseCase = SaveDailyEntryUseCase(repository: repository)
        let deleteDailyEntryUseCase = DeleteDailyEntryUseCase(repository: repository)
        
        self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(
            getDailyEntriesUseCase: getDailyEntriesUseCase,
            saveDailyEntryUseCase: saveDailyEntryUseCase,
            deleteDailyEntryUseCase: deleteDailyEntryUseCase
        ))
    }
    
    var body: some View {
        NavigationView {
            if welcomeViewModel.isFirstLaunch {
                WelcomeScreen(
                    onGetStarted: {
                        welcomeViewModel.completeWelcome()
                    }
                )
            } else {
                CalendarScreen(viewModel: calendarViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
