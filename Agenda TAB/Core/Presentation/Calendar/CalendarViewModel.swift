import Foundation
import Combine

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var currentMonth = Date()
    @Published var dailyEntries: [Date: DailyEntry] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDate: Date?
    @Published var showEditModal = false
    @Published var showDayDetailsCard = false
    
    private let getDailyEntriesUseCase: GetDailyEntriesUseCase
    private let saveDailyEntryUseCase: SaveDailyEntryUseCase
    private let deleteDailyEntryUseCase: DeleteDailyEntryUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getDailyEntriesUseCase: GetDailyEntriesUseCase,
        saveDailyEntryUseCase: SaveDailyEntryUseCase,
        deleteDailyEntryUseCase: DeleteDailyEntryUseCase
    ) {
        self.getDailyEntriesUseCase = getDailyEntriesUseCase
        self.saveDailyEntryUseCase = saveDailyEntryUseCase
        self.deleteDailyEntryUseCase = deleteDailyEntryUseCase
        
        loadEntriesForCurrentMonth()
    }
    
    func onDaySelected(_ date: Date) {
        selectedDate = date
        showDayDetailsCard = true
        showEditModal = false
    }
    
    func onEditFromDetailsCard() {
        showDayDetailsCard = false
        showEditModal = true
    }
    
    func onDayDetailsCardDismissed() {
        showDayDetailsCard = false
        selectedDate = nil
    }
    
    func onEditModalDismissed() {
        selectedDate = nil
        showEditModal = false
        showDayDetailsCard = false
    }
    
    func onMonthChanged(_ newMonth: Date) {
        currentMonth = newMonth
        selectedDate = nil
        showDayDetailsCard = false
        showEditModal = false
        loadEntriesForMonth(newMonth)
    }
    
    func onEntryUpdated(_ entry: DailyEntry) {
        Task {
            do {
                try await saveDailyEntryUseCase.execute(entry)
                showEditModal = false
                showDayDetailsCard = true
            } catch {
                errorMessage = "Failed to save entry: \(error.localizedDescription)"
            }
        }
    }
    
    func onEntryDeleted(_ date: Date) {
        Task {
            do {
                try await deleteDailyEntryUseCase.execute(for: date)
                showEditModal = false
                showDayDetailsCard = false
                selectedDate = nil
            } catch {
                errorMessage = "Failed to delete entry: \(error.localizedDescription)"
            }
        }
    }
    
    private func loadEntriesForCurrentMonth() {
        loadEntriesForMonth(currentMonth)
    }
    
    private func loadEntriesForMonth(_ month: Date) {
        let calendar = Calendar.current
        let startDate = calendar.dateInterval(of: .month, for: month)?.start ?? month
        let endDate = calendar.dateInterval(of: .month, for: month)?.end ?? month
        
        isLoading = true
        
        getDailyEntriesUseCase.execute(from: startDate, to: endDate)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        self.errorMessage = "Failed to load entries: \(error.localizedDescription)"
                    }
                },
                receiveValue: { entries in
                    let calendar = Calendar.current
                    self.dailyEntries = Dictionary(uniqueKeysWithValues: entries.map { entry in
                        let key = calendar.startOfDay(for: entry.date)
                        return (key, entry)
                    })
                }
            )
            .store(in: &cancellables)
    }
}
